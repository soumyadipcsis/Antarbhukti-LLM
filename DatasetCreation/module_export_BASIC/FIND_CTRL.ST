(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	29. mar. 2008
programmer 	hugo
tested by	tobias

find_ctrl searches str and returns the starting position of a control character
control characters are the ascii character 00 .. 31 and 127.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FIND_CTRL

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	POS :	INT;
END_VAR


VAR_OUTPUT
	FIND_CTRL :	INT;
END_VAR


VAR
	x :	INT;
	stop :	INT;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIND_CTRL
IEC_LANGUAGE: ST
*)
stop := LEN(str);
FOR i := MAX(pos,1) TO stop DO;
    x := GET_CHAR(str,i);
	IF (x < 32) OR (x = 127) THEN
		FIND_CTRL := i;
		RETURN;
	END_IF;
END_FOR;
FIND_CTRL := 0;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	26. mar. 2008	rev 1.1
	character 127 is now recognized as control

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
