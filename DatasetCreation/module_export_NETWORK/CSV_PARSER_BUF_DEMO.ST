(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DEMO
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM CSV_PARSER_BUF_DEMO

(*Group:log*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:Default*)


VAR
	line_cnt :	INT := 2;
	col_cnt :	INT := 4;
	CPB :	CSV_PARSER_BUF;
	FS :	FILE_SERVER;
	FSD :	oscat_FILE_SERVER_DATA;
	PT :	oscat_NETWORK_BUFFER;
	sep :	BYTE;
	value :	oscat_STRING250;
	step :	INT;
	result :	BYTE;
	offset :	UDINT;
	run :	BYTE;
	done :	BOOL;
	value_real :	REAL;
	cnt :	INT;
	line :	INT;
	idx :	INT;
	data :	csv_parser_demo;
	FLOAT_TO_REAL :	FLOAT_TO_REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CSV_PARSER_BUF_DEMO
IEC_LANGUAGE: ST
*)
(* Demo-Programm: CSV-Datei mittels Enumeration auswerten
die groesse des arrays kann mittels konstanten line_cnt und col_cnt angepasst werden

 ----- den nachfolgenden Textblock als datei "csv.txt" auf der sps ablegen ---
10.45,20,30,40.8
115,3450.2123,456,123.1
---------------------------------------------------------------------------------*)

CASE step OF

00:	IF NOT done THEN
	 	(* File_Daten einrichten  *)
		FSD.FILENAME := 'csv.txt'; (* Dateiname *)
		FSD.MODE := BYTE#1; (* vorhandene Datei zum lesen öffnen *)
		FSD.OFFSET := UDINT#0; (* Start bei Dateianfang *)
		FSD.AUTO_CLOSE := T#0s; (* kein Auto-Close verwenden *)
		PT.SIZE := UINT#65535; (* maximale länge einlesen *)
		step := 10;
	END_IF;

10:	IF FSD.MODE = BYTE#0 THEN (* Datei geöffnet ? *)
		OFFSET := UDINT#0; (* Start Offset vorgeben *)
		sep := BYTE#44; (* Trennzeichen , *)
		run := BYTE#1; (* Element suchen *)
		cnt := 0;
		step := 20;
	END_IF;

20:	IF run = BYTE#0 THEN
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'CPFD: /value >~2< /offset ~3 /Run ~4 /Result ~5';
			LOG_CL.PRINTF[2] := value;
			LOG_CL.PRINTF[3] := UDINT_TO_STRING(OFFSET,'%u');
			LOG_CL.PRINTF[4] := BYTE_TO_STRING(run,'%u');
			LOG_CL.PRINTF[5] := BYTE_TO_STRING(result,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)

		run := BYTE#1; (*  nächstes Element suchen  *)

		IF result = BYTE#1 OR result = BYTE#2 THEN
			(* automatische konvertierung in real ausführen *)
			IF LEN(value) <= 20 THEN
				FLOAT_TO_REAL(FLT:=value);
				value_real := FLOAT_TO_REAL.FLOAT_TO_REAL;
			ELSE
				value_real := 0.0;
			END_IF;

			cnt := cnt + 1;
			IF cnt <= line_cnt * col_cnt THEN
				line := (cnt / col_cnt) + 1;
				idx := (cnt MOD col_cnt);
				data[line][idx] := value_real; (* Daten in Array eintragen *)
			END_IF;

		ELSIF result = BYTE#10 THEN (* nichts mehr gefunden *)
			run := BYTE#0; (* keine weitere INI Auswertung erwünscht *)
			FSD.MODE := BYTE#5; (* Datei schliessen *)
			step := 30;
		END_IF;
	END_IF;

30:	IF FSD.MODE = BYTE#0 THEN (* Datei geschlossen ? *)
		step := 0;
		done := TRUE;
	END_IF;

END_CASE;

CPB(SEP:=sep,RUN:=run,OFFSET:=offset,VALUE:=value,PT:=PT); (* CSV PARAMETER BUF *)
run:=CPB.RUN;
offset:=CPB.OFFSET;
value:=CPB.VALUE;
PT:=CPB.PT;
result:=CPB.RESULT;

FS(FSD:=FSD,PT:=PT); (* FILE_SERVER *)
FSD:=FS.FSD;
PT:=FS.PT;


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
