(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LIST_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 2.0		21. mar. 2011
programmer 	    hugo
tested by		oscat

LIST_RETRIEVE liefert das element an der stelle pos einer liste und löscht das element aus der liste.
die liste liegt als string von elementen vor die mit den zeichen SEP separiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_RETRIEVE_LAST

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_RETRIEVE_LAST :	oscat_STRING250;
END_VAR


VAR
	i :	INT;
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_RETRIEVE_LAST
IEC_LANGUAGE: ST
*)
size := LEN(LIST);
i := size;
WHILE i > 0 DO
	IF INT_TO_BYTE(GET_CHAR(LIST,i)) = SEP THEN
        LIST_RETRIEVE_LAST := RIGHT(LIST, size - i);
        LIST := LEFT(LIST, i - 1);
		RETURN;
    ELSE
        i := i - 1;
    END_IF;
END_WHILE; 
LIST_RETRIEVE_LAST := '';
LIST := '';

(* revision histroy
hm	21. mar. 2011	rev 2.0
	new module
*)
	
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
