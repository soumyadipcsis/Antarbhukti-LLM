(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	26. jul. 2009
programmer 	hugo
tested by	oscat

BINARY_TO_DWORD converts a binary string into a dword.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BIN_TO_DWORD

(*Group:Default*)


VAR_INPUT
	BIN :	oscat_STRING40;
END_VAR


VAR_OUTPUT
	BIN_TO_DWORD :	DWORD;
END_VAR


VAR
	i :	INT;
	X :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIN_TO_DWORD
IEC_LANGUAGE: ST
*)
BIN_TO_DWORD := DWORD#0;
stop := LEN(bin);
FOR I := 1 TO stop DO
    X := GET_CHAR(BIN,I);
	(* calculate the value of the digit *)
	IF X = 48 THEN
		BIN_TO_DWORD := SHL_DWORD(BIN_TO_DWORD,1);
	ELSIF X = 49 THEN
		BIN_TO_DWORD := SHL_DWORD(BIN_TO_DWORD,1) OR DWORD#1;
	END_IF;

END_FOR;


(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	20. sep. 2008	rev 1.1
	changed length of input dtring from 20 to 40

hm	26. jul 2009	rev 1.2
	optimized code
*)	
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
