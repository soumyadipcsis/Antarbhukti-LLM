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

BASE64_DECODE_STREAM konvertiert einzelne Base64 kodierte Datenblöcke in normalen Datenblöcke. 

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BASE64_DECODE_STREAM

(*Group:Default*)


VAR_IN_OUT
	BUF1 :	oscat_aB0_63;
	BUF2 :	oscat_aB0_47;
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
	o :	INT;
	off :	INT;
	i1 :	INT;
	i2 :	INT;
	c :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BASE64_DECODE_STREAM
IEC_LANGUAGE: ST
*)
IF SIZE1 <= 0 THEN SIZE2 := 0; RETURN; END_IF;
c := SIZE1 - 1;
i2 := 0;
a := 0;
b := WORD#0;
FOR i1 := 0 TO c DO
	o := BYTE_TO_INT(BUF1[i1]);
	IF o = 61  (* = *) THEN EXIT;
	ELSIF o > 96 (* a-z *) THEN off := 71;
	ELSIF o > 64 (* A-Z *) THEN off := 65;
	ELSIF o > 47 (* 0-9 *) THEN off := -4;
	ELSIF o = 43 (* + *) THEN off := -19;
	ELSIF o = 47 (* / *) THEN off := -16;
	END_IF;
	b := SHL_WORD(b,6) OR INT_TO_WORD(o - off);
	a := a + 6;
	IF a >= 8 THEN
		a := a - 8;
		BUF2[i2] := WORD_TO_BYTE(SHR(b,a));
		i2 := i2 + 1;
		b := b AND NOT SHL(WORD#16#FFFF,a);
	END_IF;
END_FOR;
SIZE2 := i2;

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
