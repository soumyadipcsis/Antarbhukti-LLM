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

the function deletes all blanks within a string.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TRIM

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	TRIM :	STRING;
END_VAR


VAR
	pos :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TRIM
IEC_LANGUAGE: ST
*)
trim := str;
REPEAT
	pos := FIND(trim,' ');
	IF pos > 0 THEN trim := REPLACE(trim,'',1,pos); END_IF;
UNTIL pos = 0 END_REPEAT;

(* revision histroy
hm	6.10.2006		rev 1.0
	original release

hm	20. mar. 2008	rev 1.1
	avoid to call replace with pos = 0 because some systems will produce an error

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
