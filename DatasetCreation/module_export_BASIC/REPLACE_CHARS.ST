(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	14. may. 2008
programmer 	hugo
tested by	hugo

REPLACE_CHARS erstezt alle character die im string src aufgeführt sind mit dem an der selben stelle im string rep gelisteten character.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REPLACE_CHARS

(*Group:Default*)


VAR_INPUT
	STR :	oscat_STRING250;
	SRC :	STRING;
	REP :	STRING;
END_VAR


VAR_OUTPUT
	REPLACE_CHARS :	oscat_STRING250;
END_VAR


VAR
	tmp :	oscat_STRING250;
	a :	INT;
	b :	INT;
	c :	oscat_STRING1;
	stp :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: REPLACE_CHARS
IEC_LANGUAGE: ST
*)
REPLACE_CHARS := STR;
(* make sure rep and src are of same length and length is > 0 *)
a := LEN(src);
b := LEN(rep);
IF a < b THEN
	rep := LEFT(rep, a);
ELSIF b < a THEN
	src := LEFT(src, b);
END_IF;

(* search the string and replace if necessary *)
stp := LEN(str);
FOR a := 1 TO stp DO
	c := MID(REPLACE_CHARS, 1, a);
	b := FIND(src, c);
	IF b > 0 THEN
        tmp := MID(rep, 1, b);
		REPLACE_CHARS := REPLACE(REPLACE_CHARS, tmp, 1, a);
	END_IF;
END_FOR;

(* revision history
hm		14. may. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
