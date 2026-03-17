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
programmer 		Tobias
tested by		hugo

ISC_NCC testet ob in einem string keine Zeichen des Strings CMP enthalten sind.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IS_NCC

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	CMP :	STRING;
END_VAR


VAR_OUTPUT
	IS_NCC :	BOOL;
END_VAR


VAR
	L :	INT;
	pos :	INT;
	temp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: IS_NCC
IEC_LANGUAGE: ST
*)
L := LEN(str);
FOR pos := 1 TO L DO
    temp := MID(str,1,pos);
	IF FIND(CMP,temp) > 0 THEN
	    IS_NCC := FALSE;
	    RETURN;
	END_IF;
END_FOR;
IS_NCC := TRUE;

(* revision history
hm	19. mar 2008	rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
