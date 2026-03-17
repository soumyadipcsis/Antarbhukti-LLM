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

findB_Num searches str backward and returns the last position of a number
a number is characterized by a letter "0..9" or "."
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FINDB_NUM

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	FINDB_NUM :	INT;
END_VAR


VAR
	pos :	INT;
	x :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FINDB_NUM
IEC_LANGUAGE: ST
*)
findB_num := 0;
pos := LEN(str);
WHILE (pos >=1) DO
    x :=GET_CHAR(str,pos);
	IF (x > 47 AND x < 58) OR x = 46 THEN
		findB_num := pos;
		RETURN;
	END_IF;
pos := pos -1;
END_WHILE;

(* revision history
hm	6. oct 2006		rev 1.0
	original version

hm	29. feb 2008	rev 1.1
	improved performance

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
