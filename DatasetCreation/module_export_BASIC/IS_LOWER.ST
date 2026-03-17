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

IS_LOWER testet ob in einem string nur kleinbuchstaben vorkommen.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IS_LOWER

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	IS_LOWER :	BOOL;
END_VAR


VAR
	pos :	INT;
	I :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: IS_LOWER
IEC_LANGUAGE: ST
*)
I := LEN(str);
FOR pos := 1 TO I DO
	IF NOT ISC_LOWER(INT_TO_BYTE(GET_CHAR(str,pos))) THEN
		IS_LOWER := FALSE;
		RETURN;
	END_IF;
END_FOR;
IS_LOWER := I>0;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
