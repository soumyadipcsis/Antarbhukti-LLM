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

DLOG_FILE_TO_SMTP der Baustein versendet die vom DLOG_STORE_FILE_CSV erzeugten Dateien als Email

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_FILE_TO_SMTP

(*Group:parameter*)


VAR_INPUT
	FILE_DELETE :	BOOL;
	TIMEOUT :	TIME := T#30s;
	DTI :	UDINT;
	DTI_OFFSET :	INT;
	RETRY :	INT;
	RETRY_TIME :	TIME := T#30s;
	DNS_IP4 :	DWORD;
END_VAR


VAR_OUTPUT
	DONE :	BOOL;
	BUSY :	BOOL;
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


VAR_IN_OUT
	SERVER :	STRING;
	MAILFROM :	STRING;
	MAILTO :	oscat_STRING250;
	SUBJECT :	STRING;
	BODY :	oscat_STRING250;
	X :	oscat_DLOG_DATA;
END_VAR


(*Group:lokal*)


VAR
	UCBD :	oscat_UNI_CIRCULAR_BUFFER_DATA;
	UCB :	UNI_CIRCULAR_BUFFER;
	SMTP_CLIENT :	SMTP_CLIENT;
	WT_1 :	TON;
	ftrig_old :	BOOL;
	files :	oscat_STRING250;
	step :	INT;
	smtp_busy :	BOOL;
	smtp_done :	BOOL;
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
NAME: DLOG_FILE_TO_SMTP
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

00:	IF UCBD.BUF_COUNT > 0 AND smtp_busy = FALSE THEN
		UCBD.D_MODE := 12; (* Daten lesen und löschen *)
		UCB(DATA:=UCBD);
		UCBD := UCB.DATA;
		files := UCBD.D_STRING;
		IF FILE_DELETE THEN
			files := CONCAT(files,';#DEL#');
		END_IF;
		cnt := 0;
		step := 10;
	END_IF;

10:	IF smtp_busy = FALSE THEN
		IF smtp_done THEN
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_SMTP: /FILE OK >~1<';
				LOG_CL.PRINTF[1] := files;
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
		IF RETRY = 0 THEN (* Transfer unbegrenzt wiederholen *)
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_SMTP: Auftrag unbegrenzt wiederholen /file: ~2';
				LOG_CL.PRINTF[2] := files;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 10; (* Transfer wiederholen *)
		ELSIF cnt >= 0 THEN
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_SMTP: Auftrag wiederholen /cnt: ~1 /file: ~2';
				LOG_CL.PRINTF[1] := INT_TO_STRING(cnt,'%d');
				LOG_CL.PRINTF[2] := files;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 10; (* Transfer wiederholen *)
		ELSE
			(*####################  DEBUG-MESSAGE  ###################################*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'F_T_SMTP: Auftrag verworfen /file: ~2';
				LOG_CL.PRINTF[2] := files;
				LOG_MSG();
			END_IF;*)
			(*########################################################################*)
			step := 0; (* Auftrag verwerfen *)
		END_IF;
	END_IF;

END_CASE;

BUSY := step = 10;
DONE := step = 0;
WT_1(IN:= step = 20, PT:= RETRY_TIME);

SMTP_CLIENT(
	ACTIVATE:= BUSY,
	TIMEOUT:= TIMEOUT,
	DTI:= DTI,
	DTI_OFFSET:= DTI_OFFSET,
	DNS_IP4:= DNS_IP4,
	SERVER:= SERVER,
	MAILFROM:= MAILFROM,
	MAILTO:= MAILTO,
	SUBJECT:= SUBJECT,
	BODY:= BODY,
	FILES:= FILES
	);
	SERVER:= SMTP_CLIENT.SERVER;
	MAILFROM:= SMTP_CLIENT.MAILFROM;
	MAILTO:= SMTP_CLIENT.MAILTO;
	SUBJECT:= SMTP_CLIENT.SUBJECT;
	BODY:= SMTP_CLIENT.BODY;
	FILES:= SMTP_CLIENT.FILES;
	smtp_done := SMTP_CLIENT.DONE;
	smtp_busy := SMTP_CLIENT.BUSY;
	ERROR_C := SMTP_CLIENT.ERROR_C;
	ERROR_T := SMTP_CLIENT.ERROR_T;

(* revision history

ks	01. jan. 2011	rev 1.0
	original version

ks	28. apr. 2011	rev 1.1
	stringfehler bei option 'file_delete'

ks	26. jul. 2011	rev 1.2
    codeoptimierung D_MODE 12
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
