(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.0	05. apr. 2011
programmer 	    hugo
tested by		oscat

ELEMENT_COUNT liefert die anzahl der elemente einer liste.
die liste liegt als string von elementen vor die mit den zeichen SEP separiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ELEMENT_COUNT

(*Group:Default*)


VAR_IN_OUT
	ELEMENT :	oscat_STRING250;
END_VAR


VAR_INPUT
	SEP :	BYTE;
END_VAR


VAR_OUTPUT
	ELEMENT_COUNT :	INT;
END_VAR


VAR
	I :	INT;
	pos :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: ELEMENT_COUNT
IEC_LANGUAGE: ST
*)
i := LEN(ELEMENT);
IF i = 0 THEN
	ELEMENT_COUNT := 0;
ELSE
	ELEMENT_COUNT := 1;
    FOR pos := 1 TO I DO
	    IF INT_TO_BYTE(GET_CHAR(ELEMENT,pos)) = SEP THEN ELEMENT_COUNT := ELEMENT_COUNT + 1; END_IF;
    END_FOR;
END_IF;

(* revision histroy
ks	5. apr. 2011	rev 1.0
	original release

*)	

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
