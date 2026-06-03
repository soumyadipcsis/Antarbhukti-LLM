(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DATA_LOG
*)
(*@KEY@:DESCRIPTION*)
version 1.2		25. jul. 2011
programmer		ks
tested by		ks

DLOG_STORE_FILE_CSV der Baustein schreibt die DLOG Parameter in einen lokale Datei im CSV-Format

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_STORE_FILE_CSV

(*Group:Default*)


VAR_INPUT
	ENABLE :	BOOL;
	TRIG_M :	BOOL;
	TRIG_T :	UDINT;
	FILENAME :	STRING;
	DTI :	UDINT;
	SEP :	BYTE;
END_VAR


VAR_OUTPUT
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	FS :	FILE_SERVER;
	FSD :	oscat_FILE_SERVER_DATA;
	PT :	oscat_NETWORK_BUFFER;
	UCB :	UNI_CIRCULAR_BUFFER;
	ra :	BOOL;
	trig_m_last :	BOOL;
	dti_last :	UDINT := udint#4294967295;(*DT#2070-02-06-06:28:15*)
	enable_last :	BOOL;
	fn_last :	STRING;
	fn :	STRING;
	init :	BOOL;
	step :	INT;
	idx :	INT;
	log_stop :	BOOL;
	buf_totalsize :	INT := 4096;
	DT_TO_STRF :	DT_TO_STRF;
	_STRING_TO_BUFFER :	_STRING_TO_BUFFER_NW;
	n :	USINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_STORE_FILE_CSV
IEC_LANGUAGE: ST
*)
X.DTI := DTI; (* Datum / Zeit eintragen *)
IF DTI <> dti_last THEN
	X.CLOCK_TRIG := TRUE;
	dti_last := DTI;
	X.STORE_TYPE := BYTE#2;
ELSE
	X.CLOCK_TRIG := FALSE;
END_IF;

IF X.ADD_HEADER = FALSE THEN (* wenn add-header und add-data gleichzeitig ansteht, dann add-data einen zyklus länger anstehen lassen *)
	X.ADD_DATA := FALSE;
END_IF;
X.ADD_HEADER := FALSE;

IF ENABLE THEN
	IF X.CLOCK_TRIG THEN
		DT_TO_STRF(DTI:=DTI,MS:=0,FMT:=FILENAME,LANG:=0); (* automatische Dateinamen generierung *)
		fn := DT_TO_STRF.DT_TO_STRF;
		IF TRIG_T > UDINT#0 THEN (* automatischer Trigger *)
			ra := DTI MOD TRIG_T = UDINT#0;
		END_IF;
	ELSE
		ra := FALSE;
	END_IF;
	IF (TRIG_M AND NOT trig_m_last) OR ra THEN (* manueller oder automatischer Trigger *)
		X.ADD_DATA := TRUE; (* Daten loggen *)
	END_IF;
	IF NOT init THEN
		init := TRUE;
		X.ADD_HEADER := TRUE; (* Spaltenüberschriften übernehmen *)
	END_IF;
END_IF;

IF (NOT ENABLE AND enable_last) OR (NE_STRING(fn,fn_last) AND step > 0) THEN (* Neg. Flanke ENABLE - Log Stop *)
	fn_last := fn;
	X.UCB.D_HEAD := WORD#16#FF00;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Element schreiben *)
	X.UCB := UCB.DATA;
	X.ADD_HEADER := TRUE; (* Spaltenüberschriften übernehmen *)
END_IF;

CASE step OF

00:	IF ENABLE THEN
		fn_last := fn;
		FSD.FILENAME := fn; (* Dateiname *)
		FSD.OFFSET := UDINT#0; (* Start bei Dateianfang *)
		FSD.AUTO_CLOSE := T#0s; (* Auto-Close *)
		step := 20;
	END_IF;

20:	IF X.UCB.BUF_COUNT > 0 THEN (* Einträge vorhanden *)
		X.UCB.D_MODE := 10;
		UCB(DATA:=X.UCB); (* Element lesen , aber noch nicht entfernen *)
		X.UCB := UCB.DATA;
		IF X.UCB.D_HEAD = WORD#16#FF00 THEN (* LOG_STOP Command *)
			X.UCB.D_MODE := 11;
			UCB(DATA:=X.UCB); (* Element entfernen *)
			X.UCB := UCB.DATA;
			log_stop := TRUE;
			step := 40; (* Daten schreiben *)
		ELSIF idx + LEN(X.UCB.D_STRING) + 2 < buf_totalsize THEN (* Platz für Element vorhanden ? *)
			X.UCB.D_MODE := 11;
			UCB(DATA:=X.UCB); (* Element entfernen *)
			X.UCB := UCB.DATA;
			_STRING_TO_BUFFER(STR:=X.UCB.D_STRING, POS:=idx, PT:=PT.BUFFER, SIZE:=INT_TO_UINT(buf_totalsize));
			PT.BUFFER:=_STRING_TO_BUFFER.PT;
			idx := idx + LEN(X.UCB.D_STRING);
			n := n + USINT#1;
			IF n = X.ID_MAX THEN (* letztes Element einer Zeile *)
				n := USINT#0;
				PT.BUFFER[idx] := BYTE#16#0D;
				idx := idx + 1;
				PT.BUFFER[idx] := BYTE#16#0A;
			ELSE
				PT.BUFFER[idx] := SEP;
			END_IF;
			idx := idx + 1;
		ELSE
			step := 40; (* Daten schreiben *)
		END_IF;
	END_IF;

40:	IF idx > 0 THEN (* Daten schreiben *)
		FSD.MODE := BYTE#3; (* create + write *)
		PT.SIZE := INT_TO_UINT(idx); (* Datenlänge eintragen *)
		idx := 0;
	END_IF;
	step := 60;

60:	IF FSD.MODE = BYTE#0 THEN
		IF log_stop THEN
			log_stop := FALSE;
			FSD.MODE := BYTE#5; (* Datei schliessen *)
			X.NEW_FILE := FSD.FILENAME;
			X.NEW_FILE_RTRIG := FALSE;
			step := 80;
		ELSE
			step := 20;
		END_IF;
	END_IF;

80:	IF FSD.MODE = BYTE#0 THEN (* Datei schliessen beendet *)
		X.NEW_FILE_RTRIG := TRUE;
		step := 0;
	END_IF;

END_CASE;

trig_m_last := TRIG_M;
enable_last := ENABLE;

FS(FSD:=FSD,PT:=PT); (* FILE_SERVER *)
FSD := FS.FSD;
PT  := FS.PT;

ERROR_C := BYTE_TO_DWORD(FSD.ERROR);
ERROR_T := SEL(FSD.ERROR > BYTE#0,BYTE#0,BYTE#1);

(* revision history
ks	01. jan. 2011	rev 1.0
	original version

ks	13. may. 2011	rev 1.1
	ADD_DATA_REQ, ERROR_T, ERROR_C hinzugefügt

ks	25. jul. 2011	rev 1.2
	HEAD informationen geändert, neuer Spaltenzähler

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
