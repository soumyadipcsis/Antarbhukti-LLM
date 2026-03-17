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
tested by		tobias

lowercase returns str while all letters A..Z and Ä.Ö,Ü are converted to lowercase.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LOWERCASE

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	LOWERCASE :	STRING;
END_VAR


VAR
	char :	BYTE;
	char2 :	BYTE;
	pos :	INT;
	l :	INT;
	str_temp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: LOWERCASE
IEC_LANGUAGE: ST
*)
LOWERCASE := str;
l := LEN(str);
FOR pos := 1 TO l DO
    char := INT_TO_BYTE(GET_CHAR(str,pos));
	char2 := TO_LOWER(char);
    IF char <> char2 THEN
    	str_temp := LOWERCASE;
      	LOWERCASE := REPLACE(str_temp,BYTE_TO_STRING(char2,'%c'),1,pos);
	END_IF;
END_FOR;

(* revision histroy
hm	6. oct. 2006	rev 1.0
	original release

hm	4. feb. 2008	rev 1.1
	improved performance
	added Ä.Ö,Ü

hm	6. mar. 2008	rev 1.2
	added support for exteded Ascii

hm	29. mar. 2008	rev 1.3
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
