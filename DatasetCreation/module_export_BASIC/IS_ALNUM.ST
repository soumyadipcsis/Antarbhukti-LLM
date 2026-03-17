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

ISC_ALNUM testet ob in einem string nur Zahlen 0..9 vorkommen.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IS_ALNUM

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	IS_ALNUM :	BOOL;
END_VAR


VAR
	char :	BYTE;
	pos :	INT;
	I :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: IS_ALNUM
IEC_LANGUAGE: ST
*)
I := LEN(str);
FOR pos := 1 TO I DO
    char := INT_TO_BYTE(GET_CHAR(str,pos));
	IF NOT (ISC_ALPHA(char) OR ISC_NUM(char)) THEN
		IS_ALNUM := FALSE;
		RETURN;
	END_IF;
END_FOR;
IS_ALNUM := I<>0;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
