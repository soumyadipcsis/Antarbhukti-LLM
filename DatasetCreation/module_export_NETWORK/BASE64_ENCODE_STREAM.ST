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

BASE64_ENCODE_STREAM konvertiert Datenblöcke in Base64. 

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BASE64_ENCODE_STREAM

(*Group:Default*)


VAR_IN_OUT
	BUF1 :	oscat_aB0_47;
	BUF2 :	oscat_aB0_63;
END_VAR


VAR_INPUT
	SIZE1 :	INT;
END_VAR


VAR_OUTPUT
	SIZE2 :	INT;
END_VAR


VAR
	a :	INT;
	b :	WORD;
	i :	INT;
	i2 :	INT;
	i3 :	INT;
	c :	INT;
	BASE64 :	oscat_STRING64 := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
END_VAR


(*@KEY@: WORKSHEET
NAME: BASE64_ENCODE_STREAM
IEC_LANGUAGE: ST
*)
IF SIZE1 <= 0 THEN
	SIZE2 := 0;
	RETURN;
END_IF;
c := SIZE1 - 1;
i2 := 0;
a := 0;
b := WORD#0;
FOR i := 0 TO c DO
	b := SHL_WORD(b,8) OR BYTE_TO_WORD(BUF1[i]);
	a := a + 8;
	WHILE a >= 6 DO
		a := a - 6;
		buf2[i2] := INT_TO_BYTE(GET_CHAR(BASE64,WORD_TO_INT(SHR(b,a)) + 1));
		i2 := i2 + 1;
		b := b AND NOT SHL(WORD#16#FFFF,a);
	END_WHILE;
END_FOR;
IF a > 0 THEN
	buf2[i2] := INT_TO_BYTE(GET_CHAR(BASE64,WORD_TO_INT(SHL(b,6 - a)) + 1));
	i2 := i2 + 1;
	i3 := i2 + WORD_TO_INT(NOT INT_TO_WORD(i2) AND WORD#2#11);
	FOR i := i2 TO i3 DO
		buf2[i] := BYTE#61;
	END_FOR;
	SIZE2 := i3 + 1;
ELSE
	SIZE2 := i2;
END_IF;

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
