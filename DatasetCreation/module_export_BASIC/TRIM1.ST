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

the function replaces all multiple blanks within a string by only one blank.
leading and ending blanks will be deleted
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TRIM1

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	TRIM1 :	STRING;
END_VAR


VAR
	pos :	INT;
	st_temp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: TRIM1
IEC_LANGUAGE: ST
*)
trim1 := str;
REPEAT
	pos := FIND(trim1,'  ');
	IF pos > 0 THEN
	  st_temp := trim1;
	  trim1 := REPLACE(trim1,' ',2,pos);
    END_IF;
UNTIL pos = 0 END_REPEAT;
(* beginning and ending blanks need to be stripped off *)
st_temp := LEFT(trim1,1);
IF EQ_STRING(st_temp,' ') THEN trim1 := DELETE(trim1,1,1); END_IF;
st_temp := RIGHT(trim1,1);
IF EQ_STRING(st_temp,' ') THEN trim1 := DELETE(trim1,1,LEN(trim1)); END_IF;

(* revision histroy
hm	4. feb. 2008    rev 1.0
	original release

hm	20. mar. 2008	rev 1.1
	avoid to call replace with pos = 0 because some systems will produce an error

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
