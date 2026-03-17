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

find_Num searches str and returns the starting position of a number
a number is characterized by a letter "0..9" or "."
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FIND_NUM

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	POS :	INT;
END_VAR


VAR_OUTPUT
	FIND_NUM :	INT;
END_VAR


VAR
	X :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIND_NUM
IEC_LANGUAGE: ST
*)
stop := LEN(str);
FOR pos := MAX(pos,1) TO stop DO;
    X :=GET_CHAR(str,pos);
	IF (X > 47 AND X < 58) OR X = 46 THEN
		find_num := pos;
		RETURN;
	END_IF;
END_FOR;
find_num := 0;

(* revision history
hm	6. oct. 2006	rev 1.0
	original version

hm	29. feb 2008	rev 1.1
	added input pos to start search at position

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
