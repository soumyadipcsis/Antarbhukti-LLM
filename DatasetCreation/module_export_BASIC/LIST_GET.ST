(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LIST_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 2.0	21. mar. 2011
programmer 	hugo
tested by	oscat

LIST_GET liefert das element an der stelle pos einer liste.
die liste liegt als string von elementen vor die mit den zeichen SEP am anfang makiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_GET

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
	POS :	INT;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_GET :	oscat_STRING250;
END_VAR


VAR
	i :	INT;
	i2 :	INT;
	cnt :	INT;
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_GET
IEC_LANGUAGE: ST
*)
cnt := 0;
size := LEN(LIST);

(* search for the n-th occurence of a separation character and store position in i *)
FOR i := 1 TO size DO
    IF cnt = pos THEN EXIT; END_IF;
    IF INT_TO_BYTE(GET_CHAR(LIST,i)) = SEP THEN
        cnt := cnt + 1;
    END_IF;
END_FOR;

FOR i2 := i TO size DO
    IF INT_TO_BYTE(GET_CHAR(LIST,i2)) = SEP THEN EXIT; END_IF; 
END_FOR;

IF i2 > i THEN
    LIST_GET := MID(LIST,i2-i,i);
ELSE
    LIST_GET := '';
END_IF;

(* revision histroy
hm	20. jun. 2008	rev 1.0
	original release

hm	19. jan. 2011	rev 1.1
	changed string(255) to strring(LIST_LENGTH)

hm	21. mar. 2011	rev 2.0
	all list elements start with SEP
*)	

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
