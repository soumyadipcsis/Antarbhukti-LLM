(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.3	12. apr. 2011
programmer 	ks
tested by	ks

HTTP_GET führt eine HTTP Abfrage einer Web-Seite bei einem WEB_Server durch, und stellt die Daten ausbereitet zu verfügung
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HTTP_GET

(*Group:Default*)


VAR_IN_OUT
	URL_DATA :	oscat_url;
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR_INPUT
	IP4 :	DWORD;
	GET :	BOOL;
	MODE :	BYTE := BYTE#2;
	UNLOCK_BUF :	BOOL;
END_VAR


VAR_OUTPUT
	HTTP_STATUS :	STRING;
	HEADER_START :	UINT;(*HTTP Header (Message Header)*)
	HEADER_STOP :	UINT;(*HTTP Header (Message Header)*)
	BODY_START :	UINT;(*Message Body*)
	BODY_STOP :	UINT;(*Message Body*)
	DONE :	BOOL;
	ERROR :	DWORD;
END_VAR


VAR
	READ_HTTP :	READ_HTTP;
	BUFFER_SEARCH :	BUFFER_SEARCH_NW;
	_STRING_TO_BUFFER :	_STRING_TO_BUFFER_NW;
	IP_FIFO :	IP_FIFO;
	IS_NUM :	IS_NUM;
	ip_state :	BYTE;
	ip_id :	BYTE;
	get_last :	BOOL;
	ip4_stored :	DWORD;
	state :	INT;
	i :	INT;
	http_1_1_host :	BOOL;
	total_size :	INT;
	text :	oscat_STRING250;
	delimiter2b :	oscat_STRING2;
	delimiter4b :	oscat_STRING4;
	del_end :	oscat_STRING4;
	del_pos :	INT;
	idx :	INT;
	rcv_timeout :	BOOL;
	con_rdce :	BOOL;
END_VAR


(*Group:debug*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)(*Debug-Datenstruktur*)
END_VAR


VAR
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


(*@KEY@: WORKSHEET
NAME: HTTP_GET
IEC_LANGUAGE: ST
*)

CASE state OF 
00:	IF GET AND NOT get_last THEN (* auf positive Flanke SET warten *)
		state        := 10;
		ip4_stored   := IP4; (* aktuelle IP4 speichern *)
		DONE         := FALSE;
		total_size   := 0;
		HEADER_START := UINT#0;
		HEADER_STOP  := UINT#0;
		BODY_START   := UINT#0;
		BODY_STOP    := UINT#0;
		HTTP_STATUS  := '';
    	ERROR        := DWORD#0;
    	ip_state     := BYTE#1; (* Anmelden *)

    	(* workaround für pcworx -> kein $0D$0A als Stringkonstante möglich *)
    	delimiter2b := CONCAT(BYTE_TO_STRING(BYTE#16#0D,'%c'),BYTE_TO_STRING(BYTE#16#0A,'%c'));
    	delimiter4b := CONCAT(delimiter2b,delimiter2b);
        (*####################  DEBUG-MESSAGE  ###################################*)
        (*IF _debug_enable THEN
            LOG_CL.NEW_MSG := 'HTTP: S00 START /IP_ID ~4';
            LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
            LOG_MSG();
        END_IF;*)
        (*########################################################################*)
  	END_IF;

10:	IF ip_state = BYTE#3 THEN (* Bei IP_Control anmelden und auf freigabe warten *)
		idx := 0;
		text := CONCAT('GET ',URL_DATA.PATH);
		_STRING_TO_BUFFER(STR:=text,POS:=idx,PT:=S_BUF.BUFFER,SIZE:=UINT#4096); (* GET path in buffer kopieren *)
		S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
		idx := idx + LEN(text);

		IF LEN(URL_DATA.QUERY) > 0 THEN
			S_BUF.BUFFER[idx] := BYTE#63; (* ASCII '?' *)
			idx := idx + 1;
			_STRING_TO_BUFFER(STR:=URL_DATA.QUERY,POS:=idx,PT:=S_BUF.BUFFER,SIZE:=UINT#4096); (* QUERY in buffer kopieren *)
			S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
			idx := idx + LEN(URL_DATA.QUERY);
		END_IF;

		IF MODE >= BYTE#2 THEN (* gewünschte HTTP Version uebergeben *)
			text := ' HTTP/1.1';
		ELSE
			text := ' HTTP/1.0';
		END_IF;
		text := CONCAT(text,delimiter2b);
		_STRING_TO_BUFFER(STR:=text,POS:=idx,PT:=S_BUF.BUFFER,SIZE:=UINT#4096); (* HTTP Version in buffer kopieren *)
		S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
		idx := idx + LEN(text);

		IF MODE = BYTE#1 THEN (* HTTP/1.0 mit persistenter Verbindung gewünscht *)
			text := CONCAT('Connection: Keep-Alive',delimiter2b); (* workaround für pcworx -> kein $0D$0A als Stringkonstante möglich *)
		ELSIF MODE = BYTE#3 THEN (* HTTP/1.1 ohne persistenter Verbindung gewünscht *)
			text := CONCAT('Connection: Close',delimiter2b); (* workaround für pcworx -> kein $0D$0A als Stringkonstante möglich *)
		ELSE
			text := '';
		END_IF;
		text := CONCAT(text,URL_DATA.HEADER);
		_STRING_TO_BUFFER(STR:=text,POS:=idx,PT:=S_BUF.BUFFER,SIZE:=UINT#4096); (* HTTP Version in buffer kopieren *)
		S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
		idx := idx + LEN(text);

		text := CONCAT('Host: ',URL_DATA.DOMAIN);
		text := CONCAT(text,delimiter4b); (* workaround für pcworx -> kein $0D$0A als Stringkonstante möglich *)
		_STRING_TO_BUFFER(STR:=text,POS:=idx,PT:=S_BUF.BUFFER,SIZE:=UINT#4096); (* HTTP Host in buffer kopieren *)
		S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
		idx := idx + LEN(text);

		(* IP Datenverkehr einrichten *) 
		IF URL_DATA.PORT = WORD#0 THEN
			IP_C.C_PORT    := WORD#80;        (* Standard-Portnummer verwenden               *)
		ELSE
			IP_C.C_PORT    := URL_DATA.PORT;  (* Portnummer aus URL verwenden                *)
		END_IF;

		IP_C.C_IP       := ip4_stored;       (* IP eintragen                                  *)
		IP_C.C_MODE     := BYTE#0;           (* Mode: TCP+AKTIV+PORT+IP                       *)
		IP_C.C_ENABLE   := TRUE;             (* Verbindungsaufbau freigeben                   *)
		IP_C.TIME_RESET := TRUE;             (* Zeitueberwachung rücksetzen                   *)
		IP_C.R_OBSERVE  := TRUE;             (* Datenempfang ueberwachen                      *)
		S_BUF.SIZE      := INT_TO_UINT(idx); (* Sendelänge eintragen                          *)
		R_BUF.SIZE      := UINT#0;           (* Empfangslänge rücksetzen                      *) 

		state := 30;
        (*####################  DEBUG-MESSAGE  ###################################*)
        (*IF _debug_enable THEN
            LOG_CL.NEW_MSG := 'HTTP: S20 SEND /IP_ID ~4';
            LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
            LOG_MSG();
        END_IF;*)
        (*########################################################################*)

	END_IF;

30:	rcv_timeout := (IP_C.ERROR AND DWORD#16#0000_FF00) = DWORD#16#0000_FF00;
	con_rdce := (IP_C.ERROR AND DWORD#16#FD00_0000) = DWORD#16#FD00_0000;

	IF S_BUF.SIZE = UINT#0 THEN
		IF total_size = 0 THEN
			IF R_BUF.SIZE > UINT#15 THEN;  (* länge der empfangenen Daten prüfen *)

				(* HTTP HEADER Ende suchen -> durch $0D$A$0D$A erkennbar bei DEC RT-11,CP/M,MS-DOS,Windows *)
				del_end := delimiter4b;

				BUFFER_SEARCH(size:=R_BUF.SIZE,str:=del_end,pos:=0,ign:=FALSE,pt:=R_BUF.BUFFER);
				R_BUF.BUFFER:=BUFFER_SEARCH.pt;
				del_pos := BUFFER_SEARCH.BUFFER_SEARCH;

				(* kein Ende gefunden ? -> andere Ende-Codierung suchen *)
				IF del_pos = 0 THEN
          			(* workaround für pcworx -> kein $0A$0A als Stringkonstante möglich *)
          			del_end := CONCAT(BYTE_TO_STRING(BYTE#16#0A,'%c'),BYTE_TO_STRING(BYTE#16#0A,'%c'));

          			(* HTTP HEADER Ende suchen -> durch $A$A erkennbar bei Multics, Unix-Derivate,Mac OS X *)
          			BUFFER_SEARCH(size:=R_BUF.SIZE,str:=del_end,pos:=0,ign:=FALSE,pt:=R_BUF.BUFFER);
          			R_BUF.BUFFER:=BUFFER_SEARCH.pt;
		  			del_pos := BUFFER_SEARCH.BUFFER_SEARCH;
        		END_IF;

				IF del_pos > 0 THEN
					HEADER_START := UINT#0;
					HEADER_STOP  := INT_TO_UINT(del_pos + LEN(del_end) - 1);
					TOTAL_SIZE   := -1; (* HTTP Header empfangen aber noch keine gesamtlänge bekannt *)
				END_IF;

                (*####################  DEBUG-MESSAGE  ###################################*)
                (*IF _debug_enable THEN
                    LOG_CL.NEW_MSG := 'HTTP: S20 HEADER_START ~1 / HEADER_STOP ~2/IP_ID ~4';
                    LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
                    LOG_CL.PRINTF[1]  := UINT_TO_STRING(HEADER_START,'%u');
                    LOG_CL.PRINTF[2]  := UINT_TO_STRING(HEADER_STOP,'%u');
                    LOG_MSG();
                END_IF;*)
                (*########################################################################*)

				(* HTTP Statuscode auswerten: (kann 1.0 oder 1.1 sein *)
				READ_HTTP(size:=HEADER_STOP,pos:=0,SRC:='',pt:=R_BUF.BUFFER);
				R_BUF.BUFFER:=READ_HTTP.pt;

				i := LEN(READ_HTTP.READ_HTTP);
				IF i > 7 THEN
					(* HTTP Version von HOST auswerten 1.0 oder 1.1 *)
					text:=MID(READ_HTTP.READ_HTTP,1,3);
					http_1_1_host := EQ_STRING(text,'1');

					(* Code und Meldung isolieren *)
					HTTP_STATUS := RIGHT(READ_HTTP.READ_HTTP,i - 4);      
				END_IF;

				(* positive HTTP Anfrage ? *)
				IF FIND(HTTP_STATUS,'200') > 0 THEN

					(* 'Content-Length: Wert einlesen auswerten *)
					READ_HTTP(size:=HEADER_STOP,pos:=0,SRC:='CONTENT-LENGTH',pt:=R_BUF.BUFFER);
					R_BUF.BUFFER:=READ_HTTP.pt;
					text:=READ_HTTP.READ_HTTP;

					IF LEN(text) > 0 AND LEN(text) <= 80 THEN
						IS_NUM(str:=text);
						IF IS_NUM.IS_NUM THEN
							(* erwartete gesamtmenge an Bytes berechnen *)
							total_size := STRING_TO_INT(text)+ UINT_TO_INT(HEADER_STOP) + 1;
                            (*####################  DEBUG-MESSAGE  ###################################*)
                            (*IF _debug_enable THEN
                                LOG_CL.NEW_MSG := 'HTTP: S20 HEADER ~1, BODY ~2 TOTAL ~3 /IP_ID ~4';
                                LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
                                LOG_CL.PRINTF[1]  := UINT_TO_STRING(HEADER_STOP,'%u');
                                LOG_CL.PRINTF[2]  := INT_TO_STRING(TOTAL_SIZE-UINT_TO_INT(HEADER_STOP),'%d');
                                LOG_CL.PRINTF[3]  := INT_TO_STRING(TOTAL_SIZE,'%d');
                                LOG_MSG();
                            END_IF;*)
                            (*########################################################################*)
						END_IF;
					END_IF;
				ELSE
					ERROR := DWORD#16#000000FC; (* Fehler durch HTTP-Statuscodes *) 
				END_IF;
			END_IF;
			(* 1. bei bekannter Content-Length wird nach erhalt der erwartenen Daten die verbindung beendet *) 
			(* 2. bei persistenter Verbindung muss bei unbekannter Datenmenge auf Receive-Timeout gewartet werden *)
			(* 3. wenn nach datenempfang die verbindung vom host unterbrochen wird *)
		ELSIF (R_BUF.SIZE >= INT_TO_UINT(total_size)) OR
			(R_BUF.SIZE > UINT#0 AND total_size < 0 AND ((rcv_timeout OR con_rdce) OR (IP_C.C_STATE = BYTE#1))) THEN

			IF R_BUF.SIZE - UINT#1 > HEADER_STOP THEN (* BODY Daten vorhanden *)
				BODY_START := HEADER_STOP + UINT#1; 
				BODY_STOP  := R_BUF.SIZE - UINT#1;
                (*####################  DEBUG-MESSAGE  ###################################*)
                (*IF _debug_enable THEN
                    LOG_CL.NEW_MSG := 'HTTP: S20 BODY ~1, START ~2 END ~3 /IP_ID ~4';
                    LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
                    LOG_CL.PRINTF[1]  := UINT_TO_STRING(HEADER_STOP,'%u');
                    LOG_CL.PRINTF[2]  := UINT_TO_STRING(BODY_START,'%u');
                    LOG_CL.PRINTF[3]  := UINT_TO_STRING(BODY_STOP,'%u');
                    LOG_MSG();
                END_IF;*)
                (*########################################################################*)

			END_IF;

			DONE := TRUE;
			IP_C.C_ENABLE := FALSE; (* Verbindung abbauen  *)
			state := 40;
            (*####################  DEBUG-MESSAGE  ###################################*)
            (*IF _debug_enable THEN
                LOG_CL.NEW_MSG := 'HTTP: S30 OK /IP_ID ~4';
                LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
                LOG_MSG();
            END_IF;*)
            (*########################################################################*)
		END_IF;
	END_IF;

	IF IP_C.ERROR <> DWORD#0 THEN
		(* bei unbekannter Content-size ist nicht bekannt ob bzw wieviele Telegramme noch folgen werden *)
		(* darum wird nach receive-timeout oder Remote disconnect error der fehler wieder ausgefiltert (logischer fehler) *)
		IF rcv_timeout AND DONE THEN
			IP_C.ERROR := IP_C.ERROR AND DWORD#16#FFFF_00FF; (* Fehler wieder rücksetzen *)
		ELSIF con_rdce AND DONE THEN
			IP_C.ERROR := IP_C.ERROR AND DWORD#16#00FF_FFFF; (* Fehler wieder rücksetzen *)
		ELSE
			ERROR := IP_C.ERROR;
		END_IF;
	END_IF;

	IF ERROR > DWORD#0 THEN
		IP_C.C_ENABLE := FALSE; (* Verbindungsaufbau sperren           *)
		state := 40;
        (*####################  DEBUG-MESSAGE  ###################################*)
        (*IF _debug_enable THEN
            LOG_CL.NEW_MSG := 'HTTP: S30 ERROR ~1 /IP_ID ~4';
            LOG_CL.PRINTF[1]  := DWORD_TO_STRING(ERROR,'%08X');
            LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
            LOG_MSG();
        END_IF;*)
        (*########################################################################*)
	END_IF;

40:	IF (UNLOCK_BUF OR NOT DONE) THEN (* Warten auf Release und Verbindung beendet -> IP_ID vom Stack nehmen *)
		IP_STATE := BYTE#4; (* Abmelden *)
		DONE := FALSE;
		state := 0;
	END_IF;
END_CASE;

GET_LAST := GET; (* letzten Status sichern zur Flankenerkennung *)

(* IP_FIFO *)
IP_FIFO(FIFO:=IP_C.FIFO,STATE:=ip_state,ID:=ip_id);
IP_C.FIFO:=IP_FIFO.FIFO;
ip_state:=IP_FIFO.STATE;
ip_id:=IP_FIFO.ID;

(* revision history
ks	18. oct. 2008	rev 1.0
	original version

ks	20. oct. 2009	rev 1.1
	Fehler bei body-suche bei $0a$0a korrigiert,Codeoptimierung,
	new VAR del_pos , del_end (Networkbuffer und Buffer-funktionen auf Basis 0)

ks	28. oct. 2009	rev 1.2
	über url.header können zusätzliche header-infos übergeben werden

ks	12. apr. 2011	rev 1.3
	verbesserte fehlererkennung und fehlerkorrektur bei buffer_to_string
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
