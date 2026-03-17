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

del_chars deletes all characters from a string which are specified in CX.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DEL_CHARS

(*Group:x*)


VAR_INPUT
	IN :	oscat_STRING250;
	CX :	STRING;
END_VAR


VAR_OUTPUT
	DEL_CHARS :	oscat_STRING250;
END_VAR


VAR
	pos :	INT;
	stop :	INT;
	char :	oscat_STRING1;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEL_CHARS
IEC_LANGUAGE: ST
*)
(* copy input string *)
DEL_CHARS := IN;
stop := LEN(in);
pos := 1;
WHILE pos <= stop DO
    char := MID(DEL_CHARS, 1, pos);
	IF FIND(cx,char) > 0 THEN
		(* wrong chracter needs to be deleted *)
		DEL_CHARS := DELETE(DEL_CHARS, 1, pos);
		stop := stop - 1;	(* the string is one character shorter now *)
	ELSE
		(* charcter not found skip to next one *)
		pos := pos + 1;
	END_IF;
END_WHILE;

(* revision history

hm		18. jun. 2008	rev 1.0		
	original version 
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
