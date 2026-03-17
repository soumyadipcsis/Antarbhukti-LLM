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
programmer 		kurt
tested by		hugo

COUNT_CHAR how often a character CHAR occurs within a string STR.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK COUNT_CHAR

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	CHR :	BYTE;
END_VAR


VAR_OUTPUT
	COUNT_CHAR :	INT;
END_VAR


VAR
	I :	INT;
	pos :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: COUNT_CHAR
IEC_LANGUAGE: ST
*)
I := LEN(str);
COUNT_CHAR := 0;
FOR pos := 1 TO I DO
	IF INT_TO_BYTE(GET_CHAR(str,pos)) = CHR THEN COUNT_CHAR := COUNT_CHAR + 1; END_IF;
END_FOR;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
