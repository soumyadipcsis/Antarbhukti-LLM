(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	17. dec. 2008
programmer 	hugo
tested by	tobias

the function fill creates a string at length L of characters C.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILL

(*Group:Default*)


VAR_INPUT
	C :	BYTE;
	L :	INT;
END_VAR


VAR_OUTPUT
	FILL :	STRING;
END_VAR


VAR
	N :	BYTE;
	I :	INT;
	sx :	STRING;
	CHR_TO_STRING :	CHR_TO_STRING;
	FILL_tmp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILL
IEC_LANGUAGE: ST
*)
CHR_TO_STRING(C:=c);
Sx:=CHR_TO_STRING.CHR_TO_STRING;
(* create string *)
N := INT_TO_BYTE(LIMIT(0,L,80));
(* create a string of characters to be connected to str *)
FILL := '';
FOR i := 1 TO 8 DO
    FILL_tmp := FILL;
	FILL := CONCAT(FILL_tmp,FILL);
	IF BIT_OF_DWORD(BYTE_TO_DWORD(N),7) THEN FILL := CONCAT(FILL,Sx); END_IF;
	N := SHL_BYTE(N,1);
END_FOR;

(* revision histroy
hm	29. mar. 2008	rev 1.0
	original release

hm	17. dec. 2008	rev 1.1
	changed function chr to chr_to_string

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
