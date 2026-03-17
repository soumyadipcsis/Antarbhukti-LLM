(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)
version 1.4		03. dec. 2011
programmer 		ks
tested by		ks

TELNET_PRINT sendet einem TEXT in Farbe an Position X,Y an eine TELNET-Konsole

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TELNET_PRINT

(*Group:IN_OUT*)


VAR_INPUT
	TEXT :	oscat_STRING250;
	ENABLE :	BOOL;
	SEND :	BOOL;
	OPTION :	BYTE;
	BACK_COLOR :	BYTE;
	FRONT_COLOR :	BYTE;
	X_POS :	BYTE;
	Y_POS :	BYTE;
	PORT :	WORD := WORD#23;
END_VAR


VAR_OUTPUT
	READY :	BOOL;
	DONE :	BOOL;
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;
	S_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR
	_STRING_TO_BUFFER :	_STRING_TO_BUFFER_NW;
	last_fc :	BYTE;
	state :	INT;
	x :	INT := -1;
	ip_state :	BYTE;
	ip_id :	BYTE;
	IP_FIFO :	IP_FIFO;
	s_buf_size :	UINT := uint#4096;
	init :	BOOL;
	b0_screen_clear :	BOOL;
	b1_autowrap :	BOOL;
	b2_color :	BOOL;
	b3_cr_lr :	BOOL;
	b7_no_flush :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TELNET_PRINT
IEC_LANGUAGE: ST
*)
READY := IP_C.C_STATE > BYTE#127;
DONE := FALSE;

CASE state OF

00: (* Warten auf Freigabe *)
	IF ENABLE THEN
		state := 10;
		ip_state := BYTE#1; (* Anmelden *)
	END_IF;

10: (* Bei IP_Control anmelden und auf freigabe warten *)
	IF ip_state = BYTE#3 THEN

		(* IP Datenverkehr einrichten *)
		IP_C.C_PORT := PORT; (* Portnummer eintragen *)
		IP_C.C_IP := DWORD#00; (* IP eintragen *)
		IP_C.C_MODE := BYTE#4; (* Mode: TCP+PASSIV+PORT *)
		IP_C.TIME_RESET := TRUE; (* Zeitueberwachung rücksetzen *)
		IP_C.C_ENABLE := TRUE; (* Verbindungsaufbau freigeben *)
		IP_C.R_OBSERVE := FALSE; (* keine Empfangsueberwachung *)
		state := 20;
	END_IF;

20:	IF IP_C.ERROR > DWORD#0 THEN
		IP_C.TIME_RESET := TRUE; (* Fehler rücksetzen *)
	END_IF;
	IF S_BUF.SIZE = UINT#0 THEN (* Datensenden nicht aktiv *)
		IF NOT ENABLE THEN
			ip_state := BYTE#4; (* Verbindung abbauen - Ressource freigeben *)
			IP_C.C_ENABLE := FALSE; (* Verbindungsabbau *)
			state := 0;
		END_IF;
		IF IP_C.C_STATE = BYTE#1 THEN (* positive Flanke Connect off *)
			init := FALSE;
		ELSIF READY THEN (* Verbindung vorhanden *)
			IF IP_C.C_STATE = BYTE#254 AND NOT INIT THEN (* positive Flanke Connect on *)
				(* Var Init ist notwendig, damit der Baustein im selben zyklus mehrmals ausgerufen werden kann *)
				init := TRUE;
				b0_screen_clear := (OPTION AND BYTE#2#0000_0001) > BYTE#0;
				b1_autowrap := (OPTION AND BYTE#2#0000_0010) > BYTE#0;
				b2_color := (OPTION AND BYTE#2#0000_0100) > BYTE#0;
				b3_cr_lr := (OPTION AND BYTE#2#0000_1000) > BYTE#0;
				b7_no_flush := (OPTION AND BYTE#2#1000_0000) > BYTE#0;

				last_fc := NOT FRONT_COLOR; (* aktualisierung der Farben erzwingen !*)
				x := 0;

				(* AUTOWRAP OFF/ON *)
				S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC *)
				x := x +1;
				S_BUF.BUFFER[x] := BYTE#16#5B; (* [ *)
				x := x +1;
				S_BUF.BUFFER[x] := BYTE#16#3F; (* ? *)
				x := x +1;
				S_BUF.BUFFER[x] := BYTE#16#37; (* 7 *)
				x := x +1;
				S_BUF.BUFFER[x] := SEL(b1_autowrap, BYTE#16#6C (* l *),BYTE#16#68 (* h *));

				IF b0_screen_clear THEN
					IF b2_color THEN
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#5B; (* [ *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#30; (* 0 *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#3B; (* ; *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#33; (* 3 *)
						x := x +1;
						S_BUF.BUFFER[x] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30; (* Einerstelle Farbe Foreground ausgeben *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#3B; (* ; *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#34; (* 4 *)
						x := x +1;
						S_BUF.BUFFER[x] := (BACK_COLOR AND BYTE#2#00000111) OR BYTE#16#30; (* Einerstelle Farbe Background ausgeben *)
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#6D; (* m *)
					END_IF;
					(* Screen Clear *)
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC *)
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#5B; (* [ *)
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#32; (* 2 *)
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#4A; (* J *)
				ELSE
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#0A; (* neue Zeile *)
				END_IF;
			END_IF;

			(* buffer voll , oder Daten sind vorhanden und kein weiterer Sendewunsch *)
			IF (INT_TO_UINT(x + LEN(TEXT) + 21) > s_buf_size) OR (x >= 0 AND NOT SEND) THEN
				S_BUF.SIZE := INT_TO_UINT(x + 1); (* Länge eintragen -> Datensenden starten *)
				x := -1;
			ELSIF SEND THEN

				(* aktuelle Farbe bestimmen  *)
				IF b2_color AND FRONT_COLOR <> last_FC THEN
					(* Farbeinstellung: ANSI-Sequenz ESC[X;Y;Zm ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC *)
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#5B; (* [ *)
					(* Farbeinstellung: dunkel oder Hell und blinken bestimmen *)
					IF ((FRONT_COLOR AND BYTE#2#0001_1000) XOR (last_FC AND BYTE#2#0001_1000)) <> BYTE#00 OR TRUE THEN
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#30; (* 0  *)
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#3B; (* ; *)
						(* keine dunklen Farben gewünscht -> dann Bold & Bright *)
						IF (FRONT_COLOR AND BYTE#2#00001000) = BYTE#0 THEN
							(* auf Bold & Bright Farben umstellen *)
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#31; (* 1 *)
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#3B; (* ; *)
						END_IF;
						(* blinkenden Farben gewünscht *)
						IF (FRONT_COLOR AND BYTE#2#00010000) > BYTE#0 THEN
							(* auf Blinkenden Farbe umstellen *)
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#35; (* 5 *)
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#3B; (* ; *)
						END_IF;
					END_IF;
					(* Zehnerstelle Farbe Foreground ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#33; (* 3 *)
					(* Einerstelle Farbe Foreground ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30;
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#6D; (* m *)
					(* neue Farbe als letzt verwendete speichern *)
					last_FC := FRONT_COLOR;
				END_IF;

				(* Cursor positionieren *)
				IF X_POS > BYTE#0 AND Y_POS > BYTE#0 THEN
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC *)
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#5B; (* [ *)
					(* Zehnerstelle Y_POS ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := SHR(INT_TO_BCDC(BYTE_TO_INT(Y_POS)),4) OR BYTE#16#30;
					(* Einerstelle Y_POS ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := (INT_TO_BCDC(BYTE_TO_INT(Y_POS)) AND BYTE#16#0F) OR BYTE#16#30;
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#3B; (* ; *)
					(* Zehnerstelle X_POS ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := SHR(INT_TO_BCDC(BYTE_TO_INT(X_POS)),4) OR BYTE#16#30;
					(* Einerstelle X_POS ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := (INT_TO_BCDC(BYTE_TO_INT(X_POS)) AND BYTE#16#0F) OR BYTE#16#30;
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#48; (* H *)
				END_IF;

				(* text ausgeben *)
				IF LEN(TEXT) > 0 THEN
					_STRING_TO_BUFFER(str:=TEXT,pos:=x + 1,size:=s_buf_size,pt:=S_BUF.BUFFER);
    				S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
					x := x + LEN(TEXT);
				END_IF;

				IF b3_cr_lr THEN (* Option: CR,LF ausgeben *)
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#0D;
					x := x + 1;
					S_BUF.BUFFER[x] := BYTE#16#0A;
				END_IF;

				DONE := TRUE; (* Fertig in Buffer eingetragen *)

				IF b7_no_flush THEN (* Option: no buffer flush *)
					(* buffer sofort senden - aktuellen Schreibindex speichern -> Senden anstossen *)
					S_BUF.SIZE := INT_TO_UINT(x + 1);
					x := -1;
				END_IF;
			END_IF;
		END_IF;
	END_IF;
END_CASE;

(* IP_FIFO *)
IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
IP_C.FIFO:=IP_FIFO.FIFO;
IP_STATE := IP_FIFO.STATE;
IP_ID:=IP_FIFO.ID;

(* revision history
ks	05. jan. 2009	rev 1.0
	original version

ks	20. oct. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0

ks	20. oct. 2009	rev 1.2
	STRING(STRING_LENGTH)

ks	17. may. 2011	rev 1.3
	automatischer re-connect

ks	03. dec. 2011	rev 1.4
	initialisierung verbessert, Port Nummer als Parmeter

*)


































READY := IP_C.C_STATE > BYTE#127;
DONE := FALSE;

CASE state OF 

00: (* Warten auf Freigabe *)
  	IF ENABLE THEN
		state := 10;
		IP_STATE := BYTE#1; (* Anmelden *)
	END_IF;

10: (* Bei IP_Control anmelden und auf freigabe warten *)
	IF IP_STATE = BYTE#3 THEN

  		(* IP Datenverkehr einrichten *) 
  		IP_C.C_PORT     := WORD#23;                  (* Portnummer eintragen                          *)
  		IP_C.C_IP       := DWORD#00;                 (* IP eintragen                                  *)
  		IP_C.C_MODE     := BYTE#4;                   (* Mode: TCP+PASSIV+PORT                         *)
  		IP_C.TIME_RESET := TRUE;                     (* Zeitueberwachung rücksetzen                   *)
  		IP_C.C_ENABLE   := TRUE;                     (* Verbindungsaufbau freigeben                   *)
  		IP_C.R_OBSERVE  := FALSE;                    (* keine Empfangsueberwachung                    *)
  		state := 20;
	END_IF;

20: IF IP_C.ERROR > DWORD#0 THEN
		IP_C.TIME_RESET := TRUE; (* Fehler rücksetzen *)
	END_IF;
	IF S_BUF.SIZE = UINT#0 THEN	(* Datensenden nicht aktiv *) 
		IF NOT ENABLE THEN
    		IP_STATE := BYTE#4; (* Verbindung abbauen - Ressource freigeben *)
  			IP_C.C_ENABLE := FALSE; (* Verbindungsabbau *)
			state := 0;
		END_IF;
		IF IP_C.C_STATE = BYTE#1  THEN  (* positive Flanke Connect off *)
			INIT := FALSE;
		ELSIF READY THEN	(* Verbindung vorhanden *)
			IF IP_C.C_STATE = BYTE#254 AND NOT INIT THEN  (* positive Flanke Connect on *)
				(* Var Init ist notwendig, damit der Baustein im selben zyklus mehrmals ausgerufen werden kann *)
				INIT := TRUE;
				last_FC := NOT FRONT_COLOR; (* aktualisierung der Farben erzwingen !*)

				_STRING_TO_BUFFER(str:='#[?7h#[0;3#;4#m#[2J',pos:=0,size:=S_BUF_SIZE,pt:=S_BUF.BUFFER);
   				S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

				(* AUTOWRAP OFF/ON *)
				S_BUF.BUFFER[0] := BYTE#16#1B; (* ESC *)
				IF (OPTION AND BYTE#2#0000_0010) > BYTE#0 THEN
					S_BUF.BUFFER[4] := BYTE#16#6C; (* Autowrap OFF *)
				END_IF;
				x := 4; (* Schreibzeiger stellen *)
				IF (OPTION AND BYTE#2#0000_0001) > BYTE#0 THEN (* Screen Init *)

  					S_BUF.BUFFER[05] := BYTE#16#1B; (* ESC *)
  					S_BUF.BUFFER[10] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30; (* Einerstelle Farbe Foreground ausgeben *)
  					S_BUF.BUFFER[13] := (BACK_COLOR AND BYTE#2#00000111) OR BYTE#16#30; (* Einerstelle Farbe Foreground ausgeben *)
  					S_BUF.BUFFER[15] := BYTE#16#1B; (* ESC *)
					x := 18; (* Schreibzeiger stellen *)
				ELSE
        			x := x + 1;
        			S_BUF.BUFFER[x] := BYTE#16#0A; (* neue Zeile *)
				END_IF;
			END_IF;

			(* buffer voll , oder Daten sind vorhanden und kein weiterer Sendewunsch *)
			IF (INT_TO_UINT(x + LEN(TEXT) + 21) > S_BUF_SIZE) OR (x >= 0 AND NOT SEND) THEN 
				S_BUF.SIZE := INT_TO_UINT(x + 1); (* Länge eintragen -> Datensenden starten *)
				x := -1;
			ELSIF SEND THEN

      			(* aktuelle Farbe bestimmen  *)
      			IF (OPTION AND BYTE#2#0000_0100) > BYTE#0 AND FRONT_COLOR <> last_FC THEN
        			(* Farbeinstellung: ANSI-Sequenz ESC[X;Y;Zm ausgeben  *)
        			x := x + 1;
        			S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC *)
        			x := x + 1;
        			S_BUF.BUFFER[x] := BYTE#16#5B; (* [   *)
        			(* Farbeinstellung: dunkel oder Hell und blinken bestimmen *)
        			IF ((FRONT_COLOR AND BYTE#2#0001_1000) XOR (last_FC AND BYTE#2#0001_1000)) <> BYTE#00 OR TRUE THEN 
        				x := x + 1;
        				S_BUF.BUFFER[x] := BYTE#16#30; (* 0  *)
         				x := x + 1;
          				S_BUF.BUFFER[x] := BYTE#16#3B; (* ;  *)
          				(* keine dunklen Farben gewünscht -> dann Bold & Bright *)
          				IF (FRONT_COLOR AND BYTE#2#00001000) = BYTE#0 THEN 
            				(* auf Bold & Bright Farben umstellen *)
            				x := x + 1;
            				S_BUF.BUFFER[x] := BYTE#16#31; (* 1  *) 
            				x := x + 1;
            				S_BUF.BUFFER[x] := BYTE#16#3B; (* ;  *)
          				END_IF;
          				(* blinkenden Farben gewünscht *)
          				IF (FRONT_COLOR AND BYTE#2#00010000) > BYTE#0 THEN 
           					(* auf Blinkenden Farbe umstellen *)
           					x := x + 1;
           					S_BUF.BUFFER[x] := BYTE#16#35; (* 5  *) 
           					x := x + 1;
           					S_BUF.BUFFER[x] := BYTE#16#3B; (* ;  *)
        				END_IF;
        			END_IF;
        			(* Zehnerstelle Farbe Foreground ausgeben *)
        			x := x + 1;
        			S_BUF.BUFFER[x] := BYTE#16#33; (* 3  *)
        			(* Einerstelle Farbe Foreground ausgeben *)
        			x := x + 1;
        			S_BUF.BUFFER[x] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30;
        			x := x + 1;
        			S_BUF.BUFFER[x] := BYTE#16#6D; (* m  *)
        			(* neue Farbe als letzt verwendete speichern *)
        			last_FC := FRONT_COLOR;
      			END_IF;

   				(* Cursor positionieren *)
    			IF X_POS > BYTE#0 AND Y_POS > BYTE#0 THEN
    				x := x + 1;
    				S_BUF.BUFFER[x] := BYTE#16#1B; (* ESC      *)
    				x := x + 1;
    				S_BUF.BUFFER[x] := BYTE#16#5B; (* [        *)
    				(* Zehnerstelle Y_POS ausgeben *)
    				x := x + 1;
    				S_BUF.BUFFER[x] := SHR_BYTE(INT_TO_BCDC(_BYTE_TO_INT(Y_POS)),4) OR BYTE#16#30; 
    				(* Einerstelle Y_POS ausgeben *)
    				x := x + 1;
    				S_BUF.BUFFER[x] := (INT_TO_BCDC(_BYTE_TO_INT(Y_POS)) AND BYTE#16#0F) OR BYTE#16#30; 
    				x := x + INT#1;
    				S_BUF.BUFFER[x] := BYTE#16#3B; (* ;        *)
    				(* Zehnerstelle X_POS ausgeben *)
    				x := x + 1;
    				S_BUF.BUFFER[x] := SHR_BYTE(INT_TO_BCDC(_BYTE_TO_INT(X_POS)),4) OR BYTE#16#30; 
    				(* Einerstelle X_POS ausgeben *)
    				x := x + 1;
    				S_BUF.BUFFER[x] := (INT_TO_BCDC(_BYTE_TO_INT(X_POS)) AND BYTE#16#0F) OR BYTE#16#30; 
    				x := x + 1;
    				S_BUF.BUFFER[x] := BYTE#16#48; (* H        *)
				END_IF;

				(* text ausgeben *)
				IF LEN(TEXT) > 0 THEN
		 
					_STRING_TO_BUFFER(str:=TEXT,pos:=x + 1,size:=S_BUF_SIZE,pt:=S_BUF.BUFFER);
    				S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
   					x := x + LEN(TEXT);
				END_IF;

				IF (OPTION AND BYTE#2#0000_1000) > BYTE#0 THEN	(* Option: CR,LF ausgeben *)
       				x := x + 1;
       				S_BUF.BUFFER[x] := BYTE#16#0D;
       				x := x + 1;
       				S_BUF.BUFFER[x] := BYTE#16#0A;
     			END_IF;

				DONE := TRUE;	(* Fertig in Buffer eingetragen *)

				IF (OPTION AND BYTE#2#1000_0000) = BYTE#0 THEN	(* Option: no buffer flush *)
					(* buffer sofort senden - aktuellen Schreibindex speichern -> Senden anstossen *)
					S_BUF.SIZE := INT_TO_UINT(x + 1);
					x := -1;
				END_IF;
     		END_IF;
		END_IF;
	END_IF;
END_CASE;

(* IP_FIFO *)
IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
IP_C.FIFO:=IP_FIFO.FIFO;
IP_STATE := IP_FIFO.STATE;
IP_ID:=IP_FIFO.ID;

(* revision history
ks	05. jan. 2009	rev 1.0
	original version

ks	20. oct. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0

ks	20. oct. 2009	rev 1.2
	STRING(STRING_LENGTH)

ks	17. may. 2011	rev 1.3
	automatischer re-connect
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
