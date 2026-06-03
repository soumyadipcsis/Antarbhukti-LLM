(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HARDWARE
*)
(*@KEY@:DESCRIPTION*)

version 1.8		26. july. 2011
programmer 		ks
tested by		ks

IP_CONTROL ist ein Wrapper-Baustein um eine Hersteller neutrale Schnittstelle zum Ethernet zu schaffen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IP_CONTROL

(*Group:debug*)


VAR
	(*<debug_index :	INT;>*)(*test debug*)
	(*<debug_ID :	INT;>*)(*test debug*)
	(*<debug_lasterror :	DWORD;>*)(*test debug*)
	(*<debug_last_id :	INT := 255;>*)(*test debug*)
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)(*Debug-Datenstruktur*)
END_VAR


VAR
	(*<LOG_MSG :	LOG_MSG;>*)(*Debug-Bausteininstanz*)
END_VAR


(*Group:instance*)


VAR
	T_PLC_MS :	T_PLC_MS;(*Bausteininstanz T_PLC_MS*)
	IP4_TO_STRING :	IP4_TO_STRING;(*Bausteininstanz*)
	FB_IP_CONNECT :	IP_CONNECT;(*Bausteininstanz IP_CONNECT*)
	FB_IP_URCV :	IP_URCV;(*Bausteininstanz IP_RECEIVE*)
	FB_IP_USEND :	IP_USEND;(*Bausteininstanz IP_SEND*)
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
	IP :	DWORD;(*IP Adresse*)
	PORT :	WORD;(*Port Nummer*)
	TIME_OUT :	TIME;(*Ueberwachungszeit Connect / Send / Receive*)
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;(*Externer Sendbuffer*)
	R_BUF :	oscat_NETWORK_BUFFER;(*Externer Receivebuffer*)
END_VAR


(*Group:lokal*)


VAR
	C_TIME :	UDINT;(*CONNECT-Time (Zeit bei nicht vorhandener Verbindung)*)
	S_TIME :	UDINT;(*SEND-Time    (Zeit seit letzten Datensenden)*)
	R_TIME :	UDINT;(*RECEIVE-Time (Zeit seit letztem Datenempfang)*)
	C_ENABLE :	BOOL;(*CONNECT freigabe*)
	C_IP :	DWORD;(*Connect: aktuelle IP-Adresse*)
	C_PORT :	WORD;(*Connect: aktuelle Port-Nummer*)
	C_MODE :	BYTE;(*Connect: aktueller Mode UDP/TCP......*)
	C_ERROR :	BOOL;(*Connect Error vorhanden*)
	C_STATUS :	INT;(*Connect Status (Errorcode)*)
	C_ID :	INT;(*Connect ID für Send und Receive Baustein*)
	C_RECONNECT :	BOOL;(*Reconnect durchführen*)
	C_RECONNECT_COUNT :	INT;(*Reconnect zähler*)
	S_BUF_I :	oscat_NETWORK_BUFFER_SHORT;(*interner Sendbuffer*)
	S_TOTAL :	INT;(*Gesamtanzahl Bytes zum senden*)
	S_CUR_POS :	INT;(*aktuelle Sendeposition*)
	S_CUR_SIZE :	INT;(*aktuelle Sendegroesse*)
	S_MAX_SIZE :	INT := 1408;(*maximale Telegrammlänge fuer Senden*)
	S_START :	BOOL;(*Mode für IP_SEND Aufruf*)
	S_REQ :	BOOL;(*pos. Flanke Start Daten senden*)
	S_DONE :	BOOL;(*Senden ohne Fehler beendet*)
	S_ERROR :	BOOL;(*Sende Error vorhanden*)
	S_STATUS :	INT;(*Sende Status (Errorcodes)*)
	R_NDR :	BOOL;(*pos. Flanke wenn neue Daten empfangen wurden*)
	R_ERROR :	BOOL;(*Receive Error vorhanden*)
	R_STATUS :	INT;(*Receive Status (Errorcodes)*)
	R_BUF_I :	oscat_NETWORK_BUFFER_SHORT;(*Interner Receivebuffer*)
	R_COUNT :	INT;(*Receive Anzahl empfangener Bytes*)
	R_OFFSET :	INT;(*aktuelle Position in externen Receivebuffer*)
	R_E_MAX_SIZE :	INT := 4096;(*groesse des externen Empfangbuffers*)
	NEW_CONNECTION :	BOOL;(*Neue Verbindungsparameter vorhanden*)
	C_ENABLE_OLD :	BOOL;(*letzter Zustand von C_ENABLE für Flankenauswertung*)
	C_READY :	BOOL;(*Verbindung aufgebaut*)
	C_READY_OLD :	BOOL;(*letzter Zustand von C_READY für Flankenauswertung*)
	DELAY_STOP :	UDINT;(*PCWORX Workaround*)
	DELAY :	UDINT;(*PCWORX Workaround*)
	DELAY_VALUE :	UDINT;(*PCWORX Workaround*)
	C :	INT;(*temp*)
	C2 :	INT;(*temp*)
	C3 :	INT;(*temp*)
	CS :	STRING;(*Connect PARTNER STRING*)
	TX :	UDINT;(*letzter zeitwert*)
	ERROR_TIME :	UDINT;(*aktueller Timeout-Wert*)
	S_ACTIVE :	BOOL;(*Daten senden ist aktiv*)
	ERROR_CON :	BYTE;(*Error Connect*)
	ERROR_SND :	BYTE;(*Error Send*)
	ERROR_RCV :	BYTE;(*Error Receive*)
END_VAR


(*@KEY@: WORKSHEET
NAME: CONNECT
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
TX := T_PLC_MS.T_PLC_MS;

(*++++++ PCWORX spez. Sonderbehandlung bei Connect on/off ++++++++++++++++++*)

(* bei Connect on/off aktivitäten muss die abarbeitung zeitverzögert werden *)
IF (TX - DELAY < DELAY_VALUE) THEN
  IF IP_C.C_STATE <> BYTE#1 AND IP_C.C_STATE <> BYTE#254 THEN (* Bei vorhandenen Connect OFF/ON Flankenmeldungen die abarbeitet nicht unterbrechen *)
	RETURN;
  END_IF;
END_IF;
DELAY := TX;

(*####################  DEBUG-MESSAGE  ###################################*)
(*IF _debug_enable THEN
	IF IP_C.FIFO.ID > BYTE#0 THEN
		debug_index := IP_C.FIFO.NR;
    	debug_ID := BYTE_TO_INT(IP_C.FIFO.X[debug_index]);
	END_IF;
END_IF;*)
(*########################################################################*)

(* Connect on/off verzoegerung nach 1000ms wieder zurücknehmen *)
IF C_ENABLE AND DELAY_VALUE > UDINT#00 THEN
  IF (TX - DELAY_STOP > UDINT#1000) THEN 
    DELAY_VALUE := UDINT#00;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'IP_CON: STOP CYCLE_DELAY -IP_ID ~6';
      LOG_CL.PRINTF[1] := CS;
      LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;
ELSE
  DELAY_STOP := TX;  (* timer starten              *)
END_IF;
(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)

(* -----------------------------------------------------------------*)
(* wenn ein satelliten-baustein die portnummer 0 oder IP-Adresse    *)
(* 0.0.0.0 verwendet, sollen die am ip_control angegebene daten     *)
(* verwendet werden.           										*)
(* -----------------------------------------------------------------*)
IF IP_C.C_PORT = WORD#00 THEN
	IP_C.C_PORT := PORT; (* uebergebenen PORT durch paramtrierte PORT ersetzen *)
END_IF;
IF IP_C.C_IP=DWORD#00 AND IP_C.C_MODE<BYTE#4 THEN
	IP_C.C_IP := IP; (* uebergebene IP durch paramtrierte IP ersetzen *)
END_IF;

(* neue Verbindungs erwünscht ? *)
NEW_CONNECTION := C_IP <> IP_C.C_IP OR C_MODE <> IP_C.C_MODE OR C_PORT <> IP_C.C_PORT;

(* -----------------------------------------------------------------*)
(* Verbindungsparameter ausbereiten                                 *)
(* -----------------------------------------------------------------*)
IF IP_C.C_ENABLE AND NOT C_READY AND NEW_CONNECTION THEN

  (* neue Verbindungsparameter übernehmen *)
  C_IP   := IP_C.C_IP; 
  C_MODE := IP_C.C_MODE;
  C_PORT := IP_C.C_PORT;

  (* -----------------------------------------------------------------*)
  (* CONNECTION_STRING erzeugen                                       *)
  (* Beispiel: '/UDP /ACTIVE /PORT=1000 /IP=192.168.178.1'            *)
  (*                                                                  *)
  (* Mode:                                                            *)
  (*  0: TCP + ACTIVE  + PORT + IP                                    *)
  (*  1: UDP + ACTIVE  + PORT + IP                                    *)
  (*  2: TCP + PASSIVE + PORT + IP                                    *)
  (*  3: UDP + PASSIVE + PORT + IP                                    *)
  (*  4: TCP + PASSIVE + PORT                                         *)
  (*  5: UDP + PASSIVE + PORT                                         *)
  (* -----------------------------------------------------------------*)

  (* bei allen ungeraden MODE Nummern UDP-String vorgeben *) 
  CS := SEL_STRING((C_MODE AND BYTE#1) = BYTE#1,'','/UDP');
  (* ACTIVE oder PASSIVE String anhängen *)
  CS := CONCAT(CS,SEL_STRING(C_MODE<BYTE#2,' /PASSIVE',' /ACTIVE'));
  (* Portnummer String anhängen *)
  CS := CONCAT(CS,' /PORT=');
  CS := CONCAT(CS,WORD_TO_STRING(C_PORT,'%u'));

  IF C_MODE<BYTE#4 THEN 
    IP4_TO_STRING(IP4:=C_IP);  (* String mit IP erzeugen *)
    CS := CONCAT(CS,' /IP=');
    CS := CONCAT(CS,IP4_TO_STRING.IP4_TO_STRING);
  END_IF;

  (*-------------------------------------------------------------------*)

  (* uebergebenen Timeout-Wert auf min-wert begrenzen *)
  ERROR_TIME := MAX(UDINT#200,TIME_TO_UDINT(TIME_OUT));
  IP_C.TIME_RESET := TRUE;   (* Alle Timer ruecksetzen *)
  (*####################  DEBUG-MESSAGE  ###################################*)
  (*IF _debug_enable THEN
    LOG_CL.NEW_MSG := 'IP_CON: ~1 -IP_ID ~6';
    LOG_CL.PRINTF[1] := CS;
    LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
    LOG_MSG();
  END_IF;*)
  (*########################################################################*)

END_IF;

(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)

C_ENABLE := IP_C.C_ENABLE AND NOT C_RECONNECT AND NOT NEW_CONNECTION AND IP_C.ERROR = DWORD#0;

(* -----------------------------------------------------------------*)
(* Systembaustein IP_CONNECT                                        *)
(* -----------------------------------------------------------------*)
FB_IP_CONNECT.EN_C    := C_ENABLE;  
FB_IP_CONNECT.PARTNER := CS;
FB_IP_CONNECT(); 
C_READY  := FB_IP_CONNECT.VALID;
C_ERROR  := FB_IP_CONNECT.ERROR;
C_STATUS := FB_IP_CONNECT.STATUS;
C_ID     := FB_IP_CONNECT.ID;

(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)

IF C_ENABLE THEN
  IF NOT C_ENABLE_OLD THEN
    DELAY_VALUE := UDINT#50;  (* verzoegerungzeit 50ms vorgeben               *)
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'IP_CON: ENABLE + CYLCE-DELAY -IP_ID ~6';
      LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;
ELSE
  IF C_ENABLE_OLD THEN
    C_RECONNECT := FALSE;
    DELAY_VALUE := UDINT#50; (* verzoegerungzeit 50ms vorgeben                *)
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'IP_CON: DISABLE + CYLCE-DELAY -IP_ID ~6';
      LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;
END_IF;

C_ENABLE_OLD := C_ENABLE;

(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)

IF C_READY THEN
  IF NOT C_READY_OLD THEN
    (* Verbindung aufgebaut - positive Flanke erkannt*)
    IP_C.C_STATE := BYTE#254;
    DELAY_VALUE := UDINT#50;  (* verzoegerungzeit 50ms vorgeben *)
    IP_C.TIME_RESET := TRUE;  (* Alle Timer ruecksetzen *)
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'IP_CON: CONNECTED -IP_ID ~6';
      LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
 
  ELSE
    IP_C.C_STATE := BYTE#255;  (* Verbindung ist aufgebaut                      *)
  END_IF;
ELSE
  IF C_READY_OLD THEN
    (* Verbindung abgebaut - negative Flanke erkannt*)
    IP_C.C_STATE := BYTE#1;
	IP_C.MAILBOX[1] := BYTE#0; (* Receive Info rücksetzen *)
	IP_C.MAILBOX[2] := BYTE#0; (* Send-Pause rücksetzen *)
	IP_C.MAILBOX[3] := BYTE#0; (* Receive-Pause rücksetzen *)
    DELAY_VALUE := UDINT#50;  (* verzoegerungzeit 50ms vorgeben *)

    IF NOT NEW_CONNECTION THEN
      S_ACTIVE := FALSE;        (* Sendeaktivitäten stoppen *)
      S_REQ := FALSE;           (* Sendefreigabe rücksetzen *)
      S_BUF.SIZE := UINT#0;     (* Sendelänge löschen       *)
      (*IP_C.TIME_RESET := TRUE;*)  (* Alle Timer ruecksetzen   *)
    END_IF;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'IP_CON: DISCONNECTED';
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  ELSE
    IP_C.C_STATE := BYTE#000; (* Verbindung ist abgebaut *)
  END_IF;
END_IF;

C_READY_OLD := C_READY;

(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: SEND
IEC_LANGUAGE: ST
*)
C := 1; (* voreinstellung: USEND einmal durchlaufen *)
IF S_BUF.SIZE > UINT#0 THEN
  IF C_READY AND C_ENABLE THEN
    IF S_ACTIVE = FALSE AND IP_C.MAILBOX[2] = BYTE#0 THEN
	  (* Gesamtanzahl an Bytes limitieren und uebergeben *)
      S_TOTAL := LIMIT_INT(0,UINT_TO_INT(S_BUF.SIZE),R_E_MAX_SIZE);
      S_CUR_POS  := 0;
      S_CUR_SIZE := 0;
      S_START := TRUE;      (* Daten kopieren und senden anstossen *)
      S_ACTIVE := TRUE;     (* Sende-Betrieb aktivieren *)
      (*####################  DEBUG-MESSAGE  ###################################*)
      (*IF _debug_enable THEN
        LOG_CL.NEW_MSG := 'IP_SEN INIT: TOTAL: ~1 -IP_ID ~6';
        LOG_CL.PRINTF[1] := INT_TO_STRING(S_TOTAL,'%d');
        LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
        LOG_MSG();
      END_IF;*)
      (*########################################################################*)
    END_IF;

    (* Daten senden gewünscht *)
    IF S_DONE OR S_START THEN

      S_START := FALSE;
      S_CUR_POS := S_CUR_POS + S_CUR_SIZE;              (* neue Sende-Datenposition bestimmen *)
      IF S_TOTAL > S_CUR_POS THEN                      (* weitere Daten zum senden vorhanden ? *)
        S_CUR_SIZE := S_TOTAL - S_CUR_POS;
        S_CUR_SIZE:=LIMIT_INT(0,S_CUR_SIZE,S_MAX_SIZE); (* Telegrammlänge begrenzen *)

  	    C2 := S_CUR_POS;
		C3 := S_CUR_SIZE - 1;
		FOR C := 0 TO C3 DO (* Datacopy routine *)
          S_BUF_I.BUFFER[C] := S_BUF.BUFFER[C2];
		  C2 := C2 + 1;
        END_FOR;

        (*####################  DEBUG-MESSAGE  ###################################*)
        (*IF _debug_enable THEN
          LOG_CL.NEW_MSG := 'IP_SEN DATA: POS: ~1 : SIZE: ~2 TOTAL ~3 -IP_ID ~6';
          LOG_CL.PRINTF[1] := INT_TO_STRING(S_CUR_POS,'%d');
          LOG_CL.PRINTF[2] := INT_TO_STRING(S_CUR_SIZE,'%d');
          LOG_CL.PRINTF[3] := INT_TO_STRING(S_TOTAL,'%d');
          LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
          LOG_MSG();
        END_IF;*)
        (*########################################################################*)

        (* Sendelänge in Telegramm eintragen *)
        S_BUF_I.SIZE := INT_TO_UINT(S_CUR_SIZE);
	    S_TIME := tx; (* Send Timer ruecksetzen      *)
        R_TIME := tx; (* Receive Timer ruecksetzen *)
        S_REQ := TRUE;
        C := 0; (* USEND zweimal aufrufen zur erzeugung einer positiven Flanke *)

      ELSE
        (* keine weitere Sendedaten vorhanden -> Senden beenden *)      
        S_REQ := FALSE;
        S_BUF.SIZE := UINT#0;
        S_ACTIVE := FALSE;
        (*####################  DEBUG-MESSAGE  ###################################*)
        (*IF _debug_enable THEN
          LOG_CL.NEW_MSG := 'IP_SEN FINISH -IP_ID ~6';
          LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
          LOG_MSG();
        END_IF;*)
        (*########################################################################*)
      END_IF;
    END_IF;
  END_IF;
END_IF;

(* -----------------------------------------------------------------*)
(* Systembaustein IP_USEND (Datensenden)                            *)
(* -----------------------------------------------------------------*)
FOR C2 := C TO 1 DO
  FB_IP_USEND.REQ    := S_REQ AND C2=1;
  FB_IP_USEND.ID     := C_ID;
  FB_IP_USEND.R_ID   := '';
  FB_IP_USEND.SD_1   := S_BUF_I;
  FB_IP_USEND();
  S_DONE   := FB_IP_USEND.DONE;
  S_ERROR  := FB_IP_USEND.ERROR;
  S_STATUS := FB_IP_USEND.STATUS;
  S_BUF_I  := FB_IP_USEND.SD_1;
END_FOR;
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: RECEIVE
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Systembaustein IP_URCV (Datenempfang)                            *)
(* -----------------------------------------------------------------*)
FB_IP_URCV.EN_R := C_READY AND NOT S_ACTIVE AND IP_C.MAILBOX[3] = BYTE#0; 
FB_IP_URCV.ID   := C_ID;
FB_IP_URCV.R_ID := '';
FB_IP_URCV.RD_1 := R_BUF_I;
FB_IP_URCV();
R_NDR    := FB_IP_URCV.NDR;
R_ERROR  := FB_IP_URCV.ERROR;
R_STATUS := FB_IP_URCV.STATUS;
R_BUF_I  := FB_IP_URCV.RD_1;

(* -----------------------------------------------------------------*)
(* positive Flanke für Daten Empfangen abfragen                     *)
(* -----------------------------------------------------------------*)
IF R_NDR THEN
  IF R_BUF.SIZE >= INT_TO_UINT(R_E_MAX_SIZE) THEN
    R_BUF.SIZE := UINT#0;
    r_status := 254; (* Empfangsbuffer wegen Überlauf rückgesetzt *)
  END_IF;

  R_TIME := tx; (* Receive Timer ruecksetzen           *)
  R_COUNT := UINT_TO_INT(R_BUF_I.SIZE); (* Anzahl empfangener Bytes bestimmen *)
  R_OFFSET := UINT_TO_INT(R_BUF.SIZE); (* Start Offset Zielbuffer *)

  IF (C_MODE AND BYTE#2#0000_0001) = BYTE#1 THEN (* UDP MODE *)  
    r_offset := 0; (* Daten immer ab position 0 ablegen -> kein Datastream *)
  ELSE
    R_OFFSET := UINT_TO_INT(R_BUF.SIZE); (* Start Offset Zielbuffer *)
  END_IF;

  (* Datenempfang auf buffergroesse beschränken *)
  IF R_OFFSET + R_COUNT > R_E_MAX_SIZE THEN
    R_COUNT := R_E_MAX_SIZE - R_OFFSET;
  END_IF;

  (* Datacopy routine *)
  C2 := R_OFFSET;
  C3 := R_COUNT - 1;
  FOR C := 0 TO C3 DO
    R_BUF.BUFFER[C2] := R_BUF_I.BUFFER[C];
    C2 := C2 + 1;
  END_FOR;
 
  R_BUF.SIZE := INT_TO_UINT(R_OFFSET + R_COUNT); (* aktuelle buffersize eintragen *)
  IP_C.MAILBOX[1] := USINT_TO_BYTE(BYTE_TO_USINT(IP_C.MAILBOX[1]) + USINT#1); (* Receive Info *)
  IF IP_C.MAILBOX[1] = BYTE#0 THEN IP_C.MAILBOX[1] := BYTE#1; END_IF;

  (*####################  DEBUG-MESSAGE  ###################################*)
  (*IF _debug_enable THEN
    LOG_CL.NEW_MSG := 'IP_REC DATA: POS: ~1 : SIZE: ~2 TOTAL ~3 -IP_ID ~6';
    LOG_CL.PRINTF[1] := INT_TO_STRING(R_OFFSET,'%d');
    LOG_CL.PRINTF[2] := INT_TO_STRING(R_COUNT,'%d');
    LOG_CL.PRINTF[3] := UINT_TO_STRING(R_BUF.SIZE,'%u');
    LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
    LOG_MSG();
  END_IF;*)
  (*########################################################################*)

END_IF;
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: ERROR
IEC_LANGUAGE: ST
*)
(* ----------------------------------------------------------------------------*)
(* Timer bearbeitung                                                           *)
(* ----------------------------------------------------------------------------*)
IF IP_C.TIME_RESET THEN     (* Alle Timer ruecksetzen      *)
  IP_C.TIME_RESET := FALSE; (* Reset rücksetzen            *)
  C_RECONNECT_COUNT := 0;   (* Reconnect zähler rücksetzen *)
  C_TIME := tx;             (* Connect   Timer ruecksetzen *)
  S_TIME := tx;             (* Send      Timer ruecksetzen *)
  R_TIME := tx;             (* Receive   Timer ruecksetzen *)

  ERROR_CON := BYTE#0;		(* Error Connect rücksetzen    *)
  ERROR_SND := BYTE#0;		(* Error Send rücksetzen       *)
  ERROR_RCV := BYTE#0;		(* Error Receive rücksetzen    *)
END_IF;

IF IP_C.R_OBSERVE = FALSE OR s_active THEN
    R_TIME := tx;
END_IF;

C_RECONNECT := FALSE;

(* ----------------------------------------------------------------------------*)
(* Error bearbeitung                                                           *)
(*                                                                             *)
(* bei pcworx ist nur wenn error = 1  der wert von status ein echter fehler    *)
(* status bekommt bei error "0" auch manchmal andere werte                     *)
(* ----------------------------------------------------------------------------*)

(* CONNECT Fehlercodes *)
IF ERROR_CON = BYTE#0 THEN
  IF C_ERROR THEN (* Die Verbindung wurde abgebrochen ignorieren *)
	IF C_STATUS = 16#31 THEN (* Die Verbindung wurde abgebrochen *)
		ERROR_CON := BYTE#253;
	ELSE
		ERROR_CON := INT_TO_BYTE(C_STATUS);
	END_IF;
  ELSIF TX - C_TIME > ERROR_TIME AND C_ENABLE AND NOT C_READY AND C_MODE < BYTE#2 THEN (* Connect Timeout *)
    IF C_RECONNECT_COUNT >= 3 THEN
      ERROR_CON := BYTE#255; (* Timeout-Fehler ausgeben *)
    ELSE
      C_TIME := TX; (* Connect   Timer ruecksetzen            *)
      C_RECONNECT_COUNT := C_RECONNECT_COUNT + 1;
      C_RECONNECT := TRUE;
      (*####################  DEBUG-MESSAGE  ###################################*)
      (*IF _debug_enable THEN
        LOG_CL.NEW_MSG := 'IP_CON: RECONNECT -IP_ID ~6';
        LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
        LOG_MSG();
      END_IF;*)
      (*########################################################################*)

    END_IF;
  END_IF;
END_IF;

(* SEND Fehlercodes *)
IF ERROR_SND = BYTE#0 THEN
  IF S_ERROR AND S_STATUS <> 16#65 THEN (* andere Bausteininstanz arbeitet mit dieser Verbindung *)
  	ERROR_SND := INT_TO_BYTE(S_STATUS);
  ELSIF TX - S_TIME > ERROR_TIME AND S_ACTIVE THEN (* Send Timeout *)
    ERROR_SND := BYTE#255; (* Timeout-Fehler ausgeben *)
  END_IF;
END_IF;

(* RECEIVE Fehlercodes *)
IF ERROR_RCV = BYTE#0 THEN
  IF R_ERROR AND (R_STATUS <> 16#33) AND (R_STATUS <> 16#31) AND (R_STATUS <> 16#65) THEN (* Receive Timeout,Verbindungsabbruch,andere Bausteininstanz arbeitet mit dieser Verbindung, ignorieren *)
  	ERROR_RCV := INT_TO_BYTE(R_STATUS);
  ELSIF TX - R_TIME > ERROR_TIME AND C_READY AND IP_C.R_OBSERVE THEN (* Receive Timeout *)
    ERROR_RCV := BYTE#255; (* Timeout-Fehler ausgeben *)
  END_IF;
END_IF;

IP_C.ERROR := DWORD_OF_BYTE(ERROR_CON,ERROR_SND,ERROR_RCV,BYTE#0);

(*####################  DEBUG-MESSAGE  ###################################*)
(*IF _debug_enable THEN
  IF (debug_last_id <> debug_ID) AND (IP_C.ERROR <> debug_lasterror) AND (IP_C.ERROR <> DWORD#00) THEN
    LOG_CL.NEW_MSG := 'IP_ERROR ~1 -IP_ID ~6';
    LOG_CL.PRINTF[1] := DWORD_TO_STRING(IP_C.ERROR,'%08X');
    LOG_CL.PRINTF[6] := INT_TO_STRING(debug_ID,'%d');
    LOG_MSG();
	debug_lasterror := IP_C.ERROR;
	debug_last_id   := debug_ID;
  END_IF;
END_IF;*)
(*########################################################################*)

(* revision history
ks	18. oct. 2008	rev 1.0
	original version
ks	05. jan. 2009	rev 1.1
	zusätzlichen Parameter "Port" hinzugefügt, und Code bei Verbindungsaufbau angepasst
ks	28. feb. 2009	rev 1.2
	connect code angepasst und verkürzung der zyklen bei Send
ks	20. oct. 2009	rev 1.3
	network_buffer basis 0
ks	06. dec. 2009	rev 1.4
	receive_count MAILBOX[1]
ks	10. nov. 2010	rev 1.5
	send_pause MAILBOX[2] and receive_pause MAILBOX[3] 
ks	07. feb. 2011	rev 1.6
	Fehlercode 253 bei Remote-Verbindungsabbruch 
ks	30. may. 2011	rev 1.7
	Fehler bei Empfangüberwachung 
ks	26. jul. 2011	rev 1.8
	optimierung der Empfangsüberwachung
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
