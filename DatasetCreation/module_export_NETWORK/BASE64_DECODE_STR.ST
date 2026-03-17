(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)

version 1.0	06. dec. 2009
programmer 	ks
tested by	ks

BASE64_DECODE_STR konvertiert einen BASE64 kodierten String in einen normalen String. 

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BASE64_DECODE_STR

(*Group:Default*)


VAR_INPUT
	RUN :	BOOL;
END_VAR


VAR_OUTPUT
	DONE :	BOOL;
END_VAR


VAR_IN_OUT
	STR1 :	oscat_STRING192;
	STR2 :	oscat_STRING144;
END_VAR


VAR
	BASE64_DECODE_STREAM :	BASE64_DECODE_STREAM;
	run_last :	BOOL;
	buf1 :	oscat_aB0_63;
	buf2 :	oscat_aB0_47;
	mode :	INT;
	size1 :	INT;
	size2 :	INT;
	end :	INT;
	pos :	INT;
	i1 :	INT;
	i2 :	INT;
	i3 :	INT;
	STRx :	oscat_STRING64;
	BTS :	BUF_TO_STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: BASE64_DECODE_STR
IEC_LANGUAGE: ST
*)

CASE mode OF
0:	IF RUN AND NOT run_last THEN
		DONE := FALSE;
		mode := 1;
		end := LEN(STR1);
		pos := 0;
		STR2 := '';
	END_IF;
1:
	SIZE1 := MIN(48,end - pos);
	IF SIZE1 > 0 THEN

		i2 := SIZE1 - 1;
		i3 := pos + 1;
		FOR i1 := 0 TO i2 DO
			buf1[i1] := INT_TO_BYTE(GET_CHAR(STR1,i3));
			i3 := i3 + 1;
		END_FOR;

		BASE64_DECODE_STREAM(BUF1:=BUF1 ,BUF2:=BUF2 ,SIZE1:=SIZE1);
		buf1  :=BASE64_DECODE_STREAM.BUF1;
		buf2  :=BASE64_DECODE_STREAM.BUF2;
		SIZE2 :=BASE64_DECODE_STREAM.SIZE2;

		FOR i1 := 0 TO 1 DO
			BTS.REQ := i1 > 0;
			BTS.BUF_FORMAT := TRUE;
			BTS.BUF_OFFS := DINT#0;
			BTS.BUF_CNT := INT_TO_DINT(SIZE2);
			BTS.BUFFER := buf2;
			BTS.DST := STRx;
			BTS();
			buf2 := BTS.BUFFER;
			STRx := BTS.DST;
		END_FOR;
		STR2 := CONCAT(STR2,STRx);
	ELSE
		mode := 0;
		DONE := TRUE;
	END_IF;
	pos := pos + size1;
END_CASE;

run_last := RUN;

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
