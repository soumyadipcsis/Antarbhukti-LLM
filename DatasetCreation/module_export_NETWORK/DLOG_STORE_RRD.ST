(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DATA_LOG
*)
(*@KEY@:DESCRIPTION*)
version 1.2		26. jul. 2011
programmer		ks
tested by		ks

DLOG_STORE_RRD der Baustein übergibt die DLOG Parameter an einen RoundRobinDatabase-Server

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_STORE_RRD

(*Group:Default*)


VAR_INPUT
	ENABLE :	BOOL;
	TRIG_M :	BOOL;
	TRIG_T :	UDINT;
	URL :	oscat_STRING250;
	DTI :	UDINT;
	SEP :	BYTE;
	DNS_IP4 :	DWORD;
	TIMEOUT :	TIME;
END_VAR


VAR_OUTPUT
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	UCB :	UNI_CIRCULAR_BUFFER;
	IP_C :	oscat_IP_C;
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	URL_DATA :	oscat_url;
	DNS_CLIENT :	DNS_CLIENT;
	HTTP_GET :	HTTP_GET;
	IPC :	IP_CONTROL;
	ra :	BOOL;
	trig_m_last :	BOOL;
	dti_last :	UDINT := udint#4294967295;(*DT#2070-02-06-06:28:15*)
	step :	INT;
	sep_char :	oscat_STRING1;
	STRING_TO_URL :	STRING_TO_URL;
	CHR_TO_STRING :	CHR_TO_STRING;
	n :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_STORE_RRD
IEC_LANGUAGE: ST
*)
X.DTI := DTI; (* Datum / Zeit eintragen *)
IF DTI <> dti_last THEN
	X.CLOCK_TRIG := TRUE;
	dti_last := DTI;
	X.STORE_TYPE := BYTE#1;
ELSE
	X.CLOCK_TRIG := FALSE;
END_IF;

X.ADD_DATA := FALSE;

IF ENABLE THEN
	IF X.CLOCK_TRIG THEN
		IF TRIG_T > UDINT#0 THEN (* automatischer Trigger *)
			ra := DTI MOD TRIG_T = UDINT#0;
		END_IF;
	ELSE
		ra := FALSE;
	END_IF;
	IF (TRIG_M AND NOT trig_m_last) OR ra OR X.ADD_DATA_REQ THEN (* manueller, automatischer oder externer Trigger *)
		X.ADD_DATA := TRUE; (* Daten loggen *)
	END_IF;
END_IF;
X.ADD_DATA_REQ := FALSE; (* externe Anforderung rücksetzen *)

CASE step OF

00:	IF ENABLE THEN
		STRING_TO_URL(STR:=URL,DEFAULT_PROTOCOL:='',DEFAULT_PATH:=''); (* URL zerlegen *)
		URL_DATA:=STRING_TO_URL.STRING_TO_URL;
		CHR_TO_STRING(C:=SEP);
		sep_char:=CHR_TO_STRING.CHR_TO_STRING;
		ERROR_T := BYTE#0;
		ERROR_C := DWORD#0;
		step := 20;
	END_IF;

20:	IF X.UCB.BUF_COUNT >= USINT_TO_INT(X.ID_MAX) THEN (* Einträge vorhanden *)
		n := 1;
		WHILE n <= USINT_TO_INT(X.ID_MAX) DO
			X.UCB.D_MODE := 12; (* Element lesen und löschen *)
			UCB(DATA:=X.UCB);
			X.UCB := UCB.DATA;
			IF n < USINT_TO_INT(X.ID_MAX) THEN (* Trennzeichen hinzufügen *)
				X.UCB.D_STRING := CONCAT(X.UCB.D_STRING,sep_char);
			END_IF;
			IF LEN(X.UCB.D_STRING) + LEN(URL_DATA.QUERY) <= 250 THEN
				URL_DATA.QUERY := CONCAT(URL_DATA.QUERY,X.UCB.D_STRING); (* Query mit LOG-Daten ergänzen *)
				step :=40;
			ELSE
				ERROR_T := BYTE#4; (* LOG-Daten können nicht in URL gepackt werden *)
				ERROR_C := DWORD#1;
				step := 0;
			END_IF;
			n := n + 1;
		END_WHILE;;
	END_IF;

40:	IF DNS_CLIENT.DONE THEN
		step := 60;
	ELSIF (DNS_CLIENT.ERROR > DWORD#0) THEN
		ERROR_C := DNS_CLIENT.ERROR; (* Fehlerbehandlung *)
		ERROR_T := BYTE#1;
		step := 100;
	END_IF;

60:	IF HTTP_GET.DONE THEN
		n := UINT_TO_INT(HTTP_GET.BODY_START);
		IF R_BUF.BUFFER[n] <> BYTE#48 THEN (* ASCII '0' *)
			ERROR_C := DWORD#1;
			ERROR_T := BYTE#3;
		END_IF;
		step := 100;

	ELSIF HTTP_GET.ERROR > DWORD#0 THEN (* Fehlerbehandlung *)
		ERROR_C := HTTP_GET.ERROR;
		ERROR_T := BYTE#2;
		step := 100;
	END_IF;

100:	IF (NOT HTTP_GET.DONE) THEN (* UNLOCK HTTP DATA *)
		step := SEL(ERROR_T = BYTE#0, 120,0);
	END_IF;

120:	IF NOT ENABLE THEN
		X.UCB.D_MODE := 99;
		UCB(DATA:=X.UCB); (* Buffer löschen *)
		X.UCB := UCB.DATA;
		step := 0;
	END_IF;

END_CASE;

HTTP_GET(IP_C:=IP_C,S_BUF:=S_BUF,R_BUF:=R_BUF,IP4:=DNS_CLIENT.IP4,GET:=step=60,MODE:=BYTE#2,UNLOCK_BUF:=step=100,URL_DATA:=URL_DATA); (* HTTP_GET *)
IP_C     := HTTP_GET.IP_C;
S_BUF    := HTTP_GET.S_BUF;
R_BUF    := HTTP_GET.R_BUF;
URL_DATA := HTTP_GET.URL_DATA;

DNS_CLIENT(IP_C:=IP_C, S_BUF:=S_BUF, R_BUF:=R_BUF, DOMAIN:=URL_DATA.DOMAIN, IP4_DNS:= DNS_IP4, ACTIVATE:=step=40); (* DNS-Client *)
IP_C  := DNS_CLIENT.IP_C;
S_BUF := DNS_CLIENT.S_BUF;
R_BUF := DNS_CLIENT.R_BUF;

IPC(IP:= DWORD#0, PORT:= WORD#0 , TIME_OUT:= TIMEOUT, IP_C:= IP_C, S_BUF:= S_BUF, R_BUF:= R_BUF); (* IP_CONTROL *)
IP_C  := IPC.IP_C;
S_BUF := IPC.S_BUF;
R_BUF := IPC.R_BUF;

trig_m_last := TRIG_M;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version

ks	13. may. 2011	rev 1.1
	ADD_DATA_REQ hinzugefügt

ks	26. july. 2011	rev 1.2
	code optimierung D_MODE 12 und bessere fehlerauswertung
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
