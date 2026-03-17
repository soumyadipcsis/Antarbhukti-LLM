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
FUNCTION_BLOCK LIST_RETRIEVE

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
	POS :	INT;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_RETRIEVE :	oscat_STRING250;
END_VAR


VAR
	i :	INT;
	cnt :	INT;
	size :	INT;
	z :	INT;
	start :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_RETRIEVE
IEC_LANGUAGE: ST
*)
cnt := 0;
start := 0;
stop := 0;
size := LEN(LIST);
FOR i := 1 TO size DO
	IF INT_TO_BYTE(GET_CHAR(LIST,i)) = SEP THEN
		cnt := cnt + 1;
		IF cnt = POS THEN
			start := i;
			FOR i := start + 1 TO size DO
                IF INT_TO_BYTE(GET_CHAR(LIST,i)) = SEP THEN EXIT; END_IF;
			END_FOR;
			stop := i;
			EXIT;
		END_IF;
	END_IF;
END_FOR;
z := stop - start;
IF z > 1 THEN
	LIST_RETRIEVE := MID(LIST, z - 1, start + 1);
ELSE
	LIST_RETRIEVE := '';
END_IF;
IF z > 0 THEN
	LIST := DELETE(LIST, z, start);
END_IF;

(* revision histroy
hm	28. jun. 2008	rev 1.0
	original release

hm	19. jan. 2011	rev 1.1
	changed string(255) to string(LIST_LENGTH)

hm	21. mar. 2011	rev 2.0
	all elements start with SEP
*)	

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
