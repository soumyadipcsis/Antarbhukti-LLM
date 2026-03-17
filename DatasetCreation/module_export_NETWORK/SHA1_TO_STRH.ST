(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.1	03. dec. 2011
programmer 	ks
tested BY	ks

SHA1_TO_STRH konvertiert das SHA1 Hash Array in einen HEX-String

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SHA1_TO_STRH

(*Group:Default*)


VAR_INPUT
	SHA1 :	oscat_aB0_19;
END_VAR


VAR_OUTPUT
	SHA1_TO_STRH :	oscat_STRING40;
END_VAR


VAR
	buf :	oscat_aB0_39;
	i :	INT;
	tmp :	INT;
	x :	INT;
	BUF_TO_STRING :	BUF_TO_STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: SHA1_TO_STRH
IEC_LANGUAGE: ST
*)
x := 0;
FOR i := 0 TO 19 DO;
	tmp := BYTE_TO_INT(SHR_BYTE(SHA1[i],4));
	buf[x] := INT_TO_BYTE(tmp + SEL(tmp <= 9,87,48));
	x := x + 1;
	tmp := BYTE_TO_INT(SHA1[i] AND BYTE#2#1111);
	buf[x] := INT_TO_BYTE(tmp + SEL(tmp <= 9,87,48));
	x := x + 1;
END_FOR;

FOR x := 0 TO 1 DO
	BUF_TO_STRING.REQ := x > 0;
	BUF_TO_STRING.BUF_FORMAT := TRUE;
	BUF_TO_STRING.BUF_OFFS := DINT#0;
	BUF_TO_STRING.BUF_CNT := DINT#40;
	BUF_TO_STRING.BUFFER := buf;
	BUF_TO_STRING.DST := SHA1_TO_STRH;
	BUF_TO_STRING();
	buf := BUF_TO_STRING.BUFFER;
	SHA1_TO_STRH := BUF_TO_STRING.DST;
END_FOR;

(* revision history

ks	6. dec. 2009 rev 1.0
	original version

ks	3. dec. 2011 rev 1.1
	incorrect string size
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
