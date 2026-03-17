(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. mar. 2008
programmer 	hugo
tested by	tobias

code extracts the code of a character at position POS of a string STR.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CODE

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	POS :	INT;
END_VAR


VAR_OUTPUT
	CODE :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: CODE
IEC_LANGUAGE: ST
*)
IF pos < 1 OR pos > LEN(str) THEN
	CODE := BYTE#0;
	RETURN;
ELSE
    CODE := INT_TO_BYTE(GET_CHAR(STR,POS));
END_IF;

(* revision history
hm	9. mar. 2008	rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
