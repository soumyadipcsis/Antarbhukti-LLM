(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	26. jul 2009
programmer 	hugo
tested by	oscat

BINARY_TO_byte converts a binary string into a byte.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BIN_TO_BYTE

(*Group:Default*)


VAR_INPUT
	BIN :	oscat_STRING12;
END_VAR


VAR_OUTPUT
	BIN_TO_BYTE :	BYTE;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	X :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIN_TO_BYTE
IEC_LANGUAGE: ST
*)
BIN_TO_BYTE := BYTE#0;
stop := LEN(bin);
FOR I := 1 TO LEN(BIN) DO
    X := GET_CHAR(BIN,I);
	(* calculate the value of the digit *)
	IF X = 48 THEN
		BIN_TO_BYTE := SHL_BYTE(BIN_TO_BYTE,1);
	ELSIF X = 49 THEN
		BIN_TO_BYTE := SHL_BYTE(BIN_TO_BYTE,1) OR BYTE#1;
	END_IF;
END_FOR;

(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	20. sep. 2008	rev 1.1
	changed length of input string from 20 to 12

hm	26. jul. 2009	rev 1.2
	optimized code
*)	


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
