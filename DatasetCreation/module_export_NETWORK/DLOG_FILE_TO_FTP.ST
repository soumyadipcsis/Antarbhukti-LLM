(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DATA_LOG
*)
(*@KEY@:DESCRIPTION*)
version 1.1		26. jul. 2011
programmer		ks
tested by		ks

DLOG_FILE_TO_FTP der Baustein kopiert bzw verschiebt die vom DLOG_STORE_FILE_CSV erzeugten Dateien auf einem FTP-Server

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_FILE_TO_FTP

(*Group:parameter*)


VAR_INPUT
	FTP_URL :	oscat_STRING250;
	FTP_ACTIV :	BOOL;
	FILE_DELETE :	BOOL;
	TIMEOUT :	TIME := T#30s;
	RETRY :	INT;
	RETRY_TIME :	TIME := T#30s;
	DNS_IP4 :	DWORD;
	PLC_IP4 :	DWORD;
END_VAR


VAR_OUTPUT
	DONE :	BOOL;
	BUSY :	BOOL;
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


(*Group:lokal*)


VAR
	UCBD :	oscat_UNI_CIRCULAR_BUFFER_DATA;
	UCB :	UNI_CIRCULAR_BUFFER;
	FTP_CLIENT :	FTP_CLIENT;
	WT_1 :	TON;
	ftrig_old :	BOOL;
	filename :	STRING;
	step :	INT;
	ftp_busy :	BOOL;
	ftp_done :	BOOL;
	cnt :	INT;
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
NAME: DLOG_FILE_TO_FTP
IEC_LANGUAGE: ST
*)
(* neue Filenamen speichern *)
IF X.NEW_FILE_RTRIG AND ftrig_old = FALSE THEN
	UCBD.D_HEAD := WORD#1;
	UCBD.D_MODE := 1;
	UCBD.D_STRING := X.NEW_FILE;
	UCB(DATA:=UCBD); (* Daten eintragen *)
	UCBD := UCB.DATA;
END_IF;
ftrig_old := X.NEW_FILE_RTRIG;

CASE step OF

00:	IF UCBD.BUF_COUNT > 0 AND ftp_busy = FALSE THEN
		UCBD.D_MODE := 12; (* Daten lesen und löschen *)
		UCB(DATA:=UCBD);
		UCBD := UCB.DATA;
		filename := UCBD.D_STRING;
		cnt := 0;
		step := 10;
	END_IF;

10:	IF ftp_busy = FALSE THEN
		IF ftp_done THEN
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_FTP: /FILE OK >~1<';
				LOG_CL.PRINTF[1] := filename;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 0;
		ELSE
			step := 20; (* pause nach error *)
		END_IF;
	END_IF;

20:	IF WT_1.Q THEN (* Wartezeit *)
		cnt := cnt - 1;
		IF RETRY = 0 THEN (* FTP Transfer unbegrenzt wiederholen *)
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_FTP: Auftrag unbegrenzt wiederholen /file: ~2';
				LOG_CL.PRINTF[2] := filename;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 10; (* FTP Transfer wiederholen *)
		ELSIF cnt >= 0 THEN
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_FTP: Auftrag wiederholen /cnt: ~1 /file: ~2';
				LOG_CL.PRINTF[1] := INT_TO_STRING(cnt,'%d');
				LOG_CL.PRINTF[2] := filename;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 10; (* FTP Transfer wiederholen *)
		ELSE
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_FTP: Auftrag verworfen /file: ~2';
				LOG_CL.PRINTF[2] := filename;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 0; (* FTP Auftrag verwerfen *)
		END_IF;
	END_IF;

END_CASE;

BUSY := step = 10;
DONE := step = 0;
WT_1(IN:= step = 20, PT:= RETRY_TIME);

FTP_CLIENT(
	ACTIVATE:= BUSY,
	FILENAME:= filename,
	FTP_URL:= FTP_URL,
	FTP_DOWNLOAD:= FALSE,
	FTP_ACTIV:= FTP_ACTIV,
	FILE_DELETE:= FILE_DELETE,
	TIMEOUT:= TIMEOUT,
	DNS_IP4:= DNS_IP4,
	PLC_IP4:= PLC_IP4
	);
	ftp_done := FTP_CLIENT.DONE;
	ftp_busy := FTP_CLIENT.BUSY;
	ERROR_C := FTP_CLIENT.ERROR_C;
	ERROR_T := FTP_CLIENT.ERROR_T;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version

ks	26. jul. 2011	rev 1.1
    codeoptimierung D_MODE 12
	
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
