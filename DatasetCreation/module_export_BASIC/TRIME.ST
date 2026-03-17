(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	28. mar. 2008
programmer 	hugo
tested by	tobias

this function deletes all leading and ending blanks of a string.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TRIME

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	TRIME :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: TRIME
IEC_LANGUAGE: ST
*)
TRIME := str;
IF LEN(TRIME) < 1 THEN RETURN; END_IF;

WHILE (GET_CHAR(TRIME,1) = 32) DO
	TRIME := DELETE(TRIME,1,1);
END_WHILE;

(* ending blanks need to be stripped off *)
WHILE (GET_CHAR(TRIME,LEN(TRIME)) = 32) DO
	TRIME := DELETE(TRIME,1,LEN(TRIME));
END_WHILE;

(* revision histroy
hm		4. feb. 2008		rev 1.0
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
