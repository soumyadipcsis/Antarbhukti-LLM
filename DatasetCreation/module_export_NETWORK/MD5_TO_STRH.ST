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

MD5_TO_STRH konvertiert das MD5 Hash Array in einen HEX-String

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MD5_TO_STRH

(*Group:Default*)


VAR_INPUT
	MD5 :	oscat_aB0_15;
END_VAR


VAR_OUTPUT
	MD5_TO_STRH :	oscat_STRING32;
END_VAR


VAR
	buf :	oscat_aB0_31;
	x :	INT;
	BUF_TO_STRING :	BUF_TO_STRING;
	i :	INT;
	tmp :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MD5_TO_STRH
IEC_LANGUAGE: ST
*)
x := 0;
FOR i := 0 TO 15 DO;
	tmp := BYTE_TO_INT(SHR_BYTE(MD5[i],4));
	buf[x] := INT_TO_BYTE(tmp + SEL(tmp <= 9,87,48));
	x := x + 1;
	tmp := BYTE_TO_INT(MD5[i] AND BYTE#2#1111);
	buf[x] := INT_TO_BYTE(tmp + SEL(tmp <= 9,87,48));
	x := x + 1;
END_FOR;

FOR x := 0 TO 1 DO
	BUF_TO_STRING.REQ := x > 0;
	BUF_TO_STRING.BUF_FORMAT := TRUE;
	BUF_TO_STRING.BUF_OFFS := DINT#0;
	BUF_TO_STRING.BUF_CNT := DINT#32;
	BUF_TO_STRING.BUFFER := buf;
	BUF_TO_STRING.DST := MD5_TO_STRH;
	BUF_TO_STRING();
	buf := BUF_TO_STRING.BUFFER;
	MD5_TO_STRH := BUF_TO_STRING.DST;
END_FOR;

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
