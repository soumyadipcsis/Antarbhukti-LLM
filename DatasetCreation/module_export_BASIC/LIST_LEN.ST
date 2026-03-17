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

LIST_LEN liefert die anzahl der elemente einer liste.
die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_LEN

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_LEN :	INT;
END_VAR


VAR
	pos :	INT;
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_LEN
IEC_LANGUAGE: ST
*)
size := LEN(LIST);
LIST_LEN := 0;
FOR pos := 1 TO size DO
	IF INT_TO_BYTE(GET_CHAR(LIST,pos)) = SEP THEN LIST_LEN := LIST_LEN + 1; END_IF;
END_FOR;

(* revision histroy
hm	25. jun. 2008	rev 1.0
	original release

hm	16. oct. 2008	rev 1.1
	fixed a problem where list_len would only work up to LIST_LENGTH

hm	19. jan. 2001	rev 1.2
	changed string(255) to string(LIST_LENGTH)

hm	21. mar. 2011	rev 2.0
	all list elements start with SEP

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
