(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. mar. 2008
programmer 	hugo
tested by	tobias

this function reverses an input string.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MIRROR

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	MIRROR :	STRING;
END_VAR


VAR
	i :	INT;
	st_temp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: MIRROR
IEC_LANGUAGE: ST
*)
mirror := '';
i := LEN(str);
WHILE i > 0 DO
   st_temp := MID(str,1,i);
   mirror := CONCAT(mirror,st_temp);
   i := i -1;
END_WHILE;

(* revision histroy
hm	4. feb. 2008	rev 1.0
	original release

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
