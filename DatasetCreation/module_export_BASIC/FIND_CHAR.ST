(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	21. oct. 2008
programmer 	hugo
tested by	tobias

find_char searches str and returns the starting position of the first character that is not a control character.
control characters are the ascii character 00 .. 31 and 127
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FIND_CHAR

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	POS :	INT;
END_VAR


VAR_OUTPUT
	FIND_CHAR :	INT;
END_VAR


VAR
	EXT_ASCII :	BOOL;
	X :	INT;
	stop :	INT;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIND_CHAR
IEC_LANGUAGE: ST
*)
EXT_ASCII := SETUP_EXTENDED_ASCII(FALSE);

stop := LEN(str);
FOR i := MAX(pos,1) TO stop DO;
    X := GET_CHAR(str,i);
	IF X > 31 AND ((EXT_ASCII AND X <> 127) OR (NOT EXT_ASCII AND X < 127)) THEN
		FIND_CHAR := i;
		RETURN;
	END_IF;
END_FOR;
FIND_CHAR := 0;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	26. mar. 2008	rev 1.1
	char will now accept extended ascii

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)

hm	19. oct. 2008	rev 1.3
	changes setup constants
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
