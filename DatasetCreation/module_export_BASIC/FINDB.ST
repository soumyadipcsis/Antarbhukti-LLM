(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	29. mar. 2008
programmer 	hugo
tested by	tobias

the function find searches an str1 for the presence of str2 and returns the first position of str1 of the last presence in instring.
the function is similar to find except it searches from the right to left.
 a 0 is returned if the string is not found.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FINDB

(*Group:Default*)


VAR_INPUT
	STR1 :	oscat_STRING250;
	STR2 :	STRING;
END_VAR


VAR_OUTPUT
	FINDB :	INT;
END_VAR


VAR
	pos :	INT;
	length :	INT;
	string_temp :	oscat_STRING250;
END_VAR


(*@KEY@: WORKSHEET
NAME: FINDB
IEC_LANGUAGE: ST
*)
length := LEN(str2);
pos := LEN(str1) - length +1;
WHILE (pos >= 1) DO
    string_temp := MID(str1,length,pos);
    IF EQ_STRING(string_temp,str2) THEN
		FindB := pos;
		RETURN;
	END_IF;
pos := pos -1;
END_WHILE;
FindB := 0;

(* revision history
hm	6. oct 2006		rev 1.0
	original version

hm	15 dec 2007		rev 1.1
	changed code for better performance

hm	29. feb 2008	rev 1.2
	added findb := 0 for compatibility reasons

hm	29. mar. 2008	rev 1.3
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
