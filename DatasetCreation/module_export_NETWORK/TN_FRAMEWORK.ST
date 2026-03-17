(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TELNET_VISION
*)
(*@KEY@:DESCRIPTION*)
version 1.1		17. may 2011
programmer		ks
tested by		ks

TN_FRAMEWORK ist ein Grundgerüst zur Nutzung des TELNET VISION Systems, und beinhält alle Laufzeit Komponenten.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_FRAMEWORK

(*Group:default*)


VAR_IN_OUT
	us_TN_INPUT_CONTROL :	us_TN_INPUT_CONTROL;
	us_TN_SCREEN :	us_TN_SCREEN;
	us_TN_MENU :	us_TN_MENU;
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	IP_C :	oscat_IP_C;
END_VAR


VAR
	FB_IP_CONTROL :	IP_CONTROL;
	FB_TN_INPUT_CONTROL :	TN_INPUT_CONTROL;
	FB_TN_INPUT_MENU_BAR :	TN_INPUT_MENU_BAR;
	FB_TN_RECEIVE :	TN_RECEIVE;
	FB_TN_SEND_ROWS :	TN_SEND_ROWS;
	t :	TON;
END_VAR


(*@KEY@: WORKSHEET
NAME: TN_FRAMEWORK
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Initialisierung / Freigeben der Verbindung                       *)
(* -----------------------------------------------------------------*)

IF (NOT IP_C.C_ENABLE) THEN

  (* IP Datenverkehr einrichten *) 
  IP_C.C_PORT     := WORD#23;                  (* Portnummer eintragen                          *)
  IP_C.C_IP       := DWORD#00;                 (* IP eintragen                                  *)
  IP_C.C_MODE     := BYTE#4;                   (* Mode: TCP+PASSIV+PORT                         *)
  IP_C.TIME_RESET := TRUE;                     (* Zeitueberwachung rücksetzen                   *)
  IP_C.C_ENABLE   := TRUE;                     (* Verbindungsaufbau freigeben                   *)
  IP_C.R_OBSERVE  := FALSE;                    (* keine Empfangsueberwachung                    *)

END_IF;

t(IN:= IP_C.ERROR > DWORD#0, PT:=T#5s);
IF t.Q THEN
	IP_C.TIME_RESET := TRUE; (* Error Reset *)
END_IF;

(* -----------------------------------------------------------------*)
(* Telnet-Menu-Bar                                                  *)
(* -----------------------------------------------------------------*)

FB_TN_INPUT_MENU_BAR.Xus_TN_MENU    := us_TN_MENU;
FB_TN_INPUT_MENU_BAR.Xus_TN_SCREEN  := us_TN_SCREEN;
FB_TN_INPUT_MENU_BAR();
us_TN_MENU   := FB_TN_INPUT_MENU_BAR.Xus_TN_MENU;
us_TN_SCREEN := FB_TN_INPUT_MENU_BAR.Xus_TN_SCREEN;

(* -----------------------------------------------------------------*)
(* Telnet-Input-Control                                             *)
(* -----------------------------------------------------------------*)

FB_TN_INPUT_CONTROL.Xus_TN_SCREEN        := us_TN_SCREEN;
FB_TN_INPUT_CONTROL.Xus_TN_INPUT_CONTROL := us_TN_INPUT_CONTROL;
FB_TN_INPUT_CONTROL();
us_TN_SCREEN        := FB_TN_INPUT_CONTROL.Xus_TN_SCREEN;
us_TN_INPUT_CONTROL := FB_TN_INPUT_CONTROL.Xus_TN_INPUT_CONTROL;

(* -----------------------------------------------------------------*)
(* Telnet-Data-Send Line-Updates                                    *)
(* -----------------------------------------------------------------*)

FB_TN_SEND_ROWS.IP_C          := IP_C;
FB_TN_SEND_ROWS.S_BUF         := S_BUF;
FB_TN_SEND_ROWS.Xus_TN_SCREEN := us_TN_SCREEN;
FB_TN_SEND_ROWS.S_BUF_SIZE    := 4096;
FB_TN_SEND_ROWS();
IP_C         := FB_TN_SEND_ROWS.IP_C;
S_BUF        := FB_TN_SEND_ROWS.S_BUF;
us_TN_SCREEN := FB_TN_SEND_ROWS.Xus_TN_SCREEN;

(* -----------------------------------------------------------------*)
(* Telnet-Server                                                    *)
(* -----------------------------------------------------------------*)

FB_IP_CONTROL.IP_C     := IP_C;
FB_IP_CONTROL.S_BUF    := S_BUF;
FB_IP_CONTROL.R_BUF    := R_BUF;
FB_IP_CONTROL.IP       := DWORD#00;
FB_IP_CONTROL.PORT     := WORD#00;
FB_IP_CONTROL.TIME_OUT := T#2s;
FB_IP_CONTROL();
IP_C  := FB_IP_CONTROL.IP_C;
S_BUF := FB_IP_CONTROL.S_BUF;
R_BUF := FB_IP_CONTROL.R_BUF;

(* -----------------------------------------------------------------*)
(* Telnet-Data-Receive                                              *)
(* -----------------------------------------------------------------*)

FB_TN_RECEIVE.R_BUF := R_BUF;
FB_TN_RECEIVE.Xus_TN_SCREEN := us_TN_SCREEN;
FB_TN_RECEIVE();
R_BUF := FB_TN_RECEIVE.R_BUF;
us_TN_SCREEN := FB_TN_RECEIVE.Xus_TN_SCREEN;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version

ks	17. may. 2011	rev 1.1
	automatischer re-connect
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
