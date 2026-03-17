(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DRIVER
*)
(*@KEY@:DESCRIPTION*)
version 1.1		17. may. 2011
programmer 		ks
tested by		ks
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IRTRANS_SERVER

(*Group:Default*)


VAR_INPUT
	UDP_TCP :	BOOL;
END_VAR


VAR_OUTPUT
	S_ENABLE :	BOOL;
	R_ENABLE :	BOOL;
	ERROR :	DWORD;
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR
	t :	TON;
END_VAR


(*@KEY@: WORKSHEET
NAME: IRTRANS_SERVER
IEC_LANGUAGE: ST
*)
IF NOT IP_C.C_ENABLE THEN
	(* IP Datenverkehr einrichten *)
	IP_C.C_PORT := WORD#0; (* Portnummer eintragen *)
	IP_C.C_IP := DWORD#00; (* IP eintragen *)
	IP_C.C_MODE := SEL(UDP_TCP,BYTE#5,BYTE#4); (* 4 = Mode: TCP+PASSIV+PORT / 5 = Mode: UDP+PASSIV+PORT*)
	IP_C.C_ENABLE := TRUE; (* Verbindungsaufbau freigeben *)
	IP_C.R_OBSERVE := FALSE; (* Datenempfang ueberwachen *)
	IP_C.TIME_RESET := TRUE; (* Zeitueberwachung rücksetzen *)
	S_BUF.SIZE := UINT#0; (* Sendedaten rücksetzen *)
	R_BUF.SIZE := UINT#0; (* Empfangsdaten rücksetzen *)
END_IF;

R_ENABLE := IP_C.C_STATE > BYTE#127;
S_ENABLE := R_ENABLE AND (IP_C.MAILBOX[1] > BYTE#0 OR IP_C.C_MODE <> BYTE#5);
ERROR := IP_C.ERROR;

t(IN:= IP_C.ERROR > DWORD#0, PT:=T#5s);
IF t.Q THEN
	IP_C.TIME_RESET := TRUE; (* Error Reset *)
END_IF;

(* revision history
ks	6. dec 2009		rev 1.0
	original version

ks	17. may 2011		rev 1.1
	neue Fehlerausgabe und Empfangsbuffer rücksetzen
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
