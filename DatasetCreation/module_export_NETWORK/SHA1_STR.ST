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
tested BY	ks

SHA1_STREAM berechnet den SHA1 Hash eines Datenstromes

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SHA1_STR

(*Group:Default*)


VAR_INPUT
	RUN :	BOOL;
END_VAR


VAR_OUTPUT
	DONE :	BOOL;
END_VAR


VAR_IN_OUT
	STR :	oscat_STRING250;
	SHA1 :	oscat_aB0_19;
END_VAR


VAR
	run_last :	BOOL;
	SHA1_STREAM :	SHA1_STREAM;
	buf :	oscat_aB0_63;
	mode :	INT;
	size :	UDINT;
	pos :	UDINT;
	i :	INT;
	i2 :	INT;
	CODE :	CODE;
END_VAR


(*@KEY@: WORKSHEET
NAME: SHA1_STR
IEC_LANGUAGE: ST
*)

CASE mode OF
0:	(* Wait für Start *)
	IF RUN AND NOT run_last THEN
		DONE := FALSE;
		mode := 1; (* Initialisierung *)
		size := INT_TO_UDINT(LEN(STR));
	END_IF;

2:	(* Data copy and Calc *)
	IF size > UDINT#0 THEN
		i2 := 0;
		FOR i := 1 TO UDINT_TO_INT(SIZE) DO
			CODE(STR:=MID(STR,1,UDINT_TO_INT(POS) + i),POS:=1);
			buf[i2] := CODE.CODE;
			i2 := i2 + 1;
		END_FOR;
	END_IF;

3:	DONE := TRUE;
	mode := 0; (* Stop *)

END_CASE;

IF mode > 0 THEN
	SHA1_STREAM(MODE:=mode, BUF:=buf, SHA1:=SHA1, SIZE:=size);
	mode := SHA1_STREAM.MODE;
	buf := SHA1_STREAM.BUF;
	SHA1 := SHA1_STREAM.SHA1;
	size := SHA1_STREAM.SIZE;
	pos := SHA1_STREAM.POS;
END_IF;

run_last := RUN;

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
