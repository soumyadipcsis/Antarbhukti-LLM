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
programmer 	ks
tested by	ks

ELEMENT_GET liefert das element an der stelle pos einer liste.
die liste liegt als string von elementen vor die mit den zeichen SEP separiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ELEMENT_GET

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
	POS :	INT;
END_VAR


VAR_IN_OUT
	ELEMENT :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	ELEMENT_GET :	oscat_STRING250;
END_VAR


VAR
	i :	INT;
	i2 :	INT;
	cnt :	INT;
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: ELEMENT_GET
IEC_LANGUAGE: ST
*)
cnt := 0;
size := LEN(ELEMENT);

(* search for the n-th occurence of a separation character and store position in i *)
FOR i := 1 TO size DO
    IF cnt = POS THEN EXIT; END_IF;
	IF INT_TO_BYTE(GET_CHAR(ELEMENT,i)) = SEP THEN cnt := cnt + 1; END_IF;
END_FOR;

FOR i2 := i TO size DO
    IF INT_TO_BYTE(GET_CHAR(ELEMENT,i2)) = SEP THEN EXIT; END_IF; 
END_FOR;

IF i2 > i THEN
    ELEMENT_GET := MID(ELEMENT,i2-i,i);
ELSE
    ELEMENT_GET := '';
END_IF;

(* revision histroy
ks 05. apr. 2011	rev 1.0
	original release

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
