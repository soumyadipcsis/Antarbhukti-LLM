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

LIST_NEXT retrieves the next element of a list, starting from element 1 after reset or first init.
when the end of the lisat is reached a '' empty string is returned and NUL is set to true.
die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_NEXT

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
	RST :	BOOL;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LEL :	oscat_STRING250;
	NUL :	BOOL;
END_VAR


VAR
	stop :	INT;
	start :	INT;
	pos :	INT := INT#1;
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_NEXT
IEC_LANGUAGE: ST
*)
size := LEN(LIST);
IF rst THEN pos := 1; END_IF;
stop := 0;
start := pos + 1;
stop := pos;
NUL := pos > size;
FOR pos := start TO size DO
	IF INT_TO_BYTE(GET_CHAR(LIST,pos)) = SEP THEN
		EXIT;
	ELSE
		stop := stop + 1;
	END_IF;
END_FOR;
IF stop >= start THEN
	LEL := MID(LIST, stop - start + 1, start);
ELSE
    LEL := '';
END_IF;

(* revision histroy
hm	25. jun. 2008	rev 1.0
	original release

hm	19. jan. 2011	rev 1.1
	changed string(255) to string(LIST_LENGTH)	

hm	21. mar. 2011	rev 2.0
	all elements start with SEP

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
