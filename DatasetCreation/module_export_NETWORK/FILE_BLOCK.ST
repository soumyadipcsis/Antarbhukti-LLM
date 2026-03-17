(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: FILE
*)
(*@KEY@:DESCRIPTION*)
version 1.0		23. sep. 2010
programmer 		ks
tested by		ks

FILE_BLOCK liefert das angeforderte Byte einer Datei durch einlesen von möglichst grossen Datenblöcken

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILE_BLOCK

(*Group:parameter*)


VAR_IN_OUT
	MODE :	BYTE;
	FILENAME :	STRING;
	FSD :	oscat_FILE_SERVER_DATA;
	PT :	oscat_NETWORK_BUFFER;
END_VAR


VAR_INPUT
	POS :	UDINT;
END_VAR


VAR_OUTPUT
	ERROR :	BYTE;
	DATA :	BYTE;
END_VAR


(*Group:log*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:var*)


VAR
	step :	INT;
	i :	INT;
	data_start :	UDINT;
	data_stop :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILE_BLOCK
IEC_LANGUAGE: ST
*)
CASE step OF
0:	IF MODE > BYTE#0 THEN
		ERROR := BYTE#0;
		IF FSD.FILE_OPEN AND (FSD.FILE_SIZE = UDINT#0 OR POS >= FSD.FILE_SIZE) THEN
			ERROR := BYTE#255;
			MODE := BYTE#0;
		ELSIF POS < data_start OR POS > data_stop OR NOT FSD.FILE_OPEN THEN (* Daten lesen notwendig *)
			FSD.FILENAME := FILENAME;
			FSD.MODE := BYTE#1; (* open + read *)
			FSD.OFFSET := POS;
			PT.SIZE := UINT#65535; (* maximale anzahl lesen *);
			data_start := UDINT#0;
			data_stop := UDINT#0;
			step := 10;
		ELSE (* Daten sind im Buffer vorhanden *)
			i := UDINT_TO_INT(POS - data_start); (* index berechnen *)
			DATA := PT.BUFFER[i];
			MODE := BYTE#0;
			(* ---------------------- Debug-Message ----------------------------*)
			(*IF _debug_enable THEN
				LOG_CL.NEW_MSG := 'FB: Pos: ~1 Byte: ~2 >~3<';
				LOG_CL.PRINTF[1] := UDINT_TO_STRING(POS,'%03u');
				LOG_CL.PRINTF[2] := BYTE_TO_STRING(DATA,'%03u');
				LOG_CL.PRINTF[3] := BYTE_TO_STRING(DATA,'%c');
				LOG_MSG();
			END_IF;*)
			(* -----------------------------------------------------------------*)
		END_IF;
	END_IF;

10:	IF FSD.MODE = BYTE#0 THEN (* Befehl beendet *)
		IF FSD.ERROR > BYTE#0 THEN
			ERROR := FSD.ERROR; (* Fehler ausgeben *)
			MODE := BYTE#0;
		ELSE
			data_start := POS;
			data_stop := POS + UINT_TO_UDINT(PT.SIZE) - UDINT#1;
		END_IF;
		step := 0;
	END_IF;
END_CASE;

(* revision history
ks	23. sep. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
