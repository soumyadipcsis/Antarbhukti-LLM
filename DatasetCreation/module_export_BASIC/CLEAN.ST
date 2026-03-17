(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	18. jun. 2008
programmer 	hugo
tested by	oscat

Clean deletes all characters from a string except the ones specified in CX.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CLEAN

(*Group:lokal*)


(*Group:IN_OUT*)


VAR_INPUT
	IN :	oscat_STRING250;
	CX :	STRING;
END_VAR


VAR_OUTPUT
	CLEAN :	oscat_STRING250;
END_VAR


VAR
	pos :	INT;
	stop :	INT;
	char :	oscat_STRING1;
END_VAR


(*@KEY@: WORKSHEET
NAME: CLEAN
IEC_LANGUAGE: ST
*)
(* copy input string *)
CLEAN := IN;
stop := LEN(in);
pos := 1;
WHILE pos <= stop DO
    char := MID(CLEAN, 1, pos);
	IF FIND(cx,char) > 0 THEN
		(* charcter found skip to next one *)
		pos := pos + 1;
	ELSE
		(* wrong chracter needs to be deleted *)
		CLEAN := DELETE(CLEAN, 1, pos);
		stop := stop - 1;	(* the string is one character shorter now *)
	END_IF;
END_WHILE;

(* revision history

hm		18. jun. 2008	rev 1.0		
	original version 


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
