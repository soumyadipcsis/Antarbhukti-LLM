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
tested by	oscat

findB_noNum searches str backwards and returns the last position which is not a number.
a number is characterized by a letter "0..9" or "."
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FINDB_NONUM

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	FINDB_NONUM :	INT;
END_VAR


VAR
	pos :	INT;
	x :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FINDB_NONUM
IEC_LANGUAGE: ST
*)
pos := LEN(str);
WHILE (pos >=1) DO
    x :=GET_CHAR(str,pos);
	IF (X < 48 AND X <> 46) OR X > 57 THEN
		findB_nonum := pos;
		RETURN;
	END_IF;
pos := pos -1;
END_WHILE;
findB_nonum := 0;

(* revision history
hm	6. oct 2006		rev 1.0
	original version

hm	29. feb 2008	rev 1.1
	improved performance

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)

hm	21. oct. 2008	rev 1.3
	optimized code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
