(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. mar 2008
programmer 	hugo
tested by	tobias

uppercase returns str while all letters a..z and ä,ö,ü are converted to uppercase
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CAPITALIZE

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	CAPITALIZE :	STRING;
END_VAR


VAR
	char :	BYTE;
	char2 :	BYTE;
	pos :	INT;
	L :	INT;
	first :	BOOL;
	str_temp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: CAPITALIZE
IEC_LANGUAGE: ST
*)
CAPITALIZE := str;
first := TRUE;
L := LEN(str);
FOR pos := 1 TO L DO
   	char := INT_TO_BYTE(GET_CHAR(str,pos));
	IF first THEN
		char2 := TO_UPPER(char);
    	IF char <> char2 THEN
    		str_temp := CAPITALIZE;
      		CAPITALIZE := REPLACE(str_temp,BYTE_TO_STRING(char2,'%c'),1,pos);
		END_IF;
	END_IF;
	(* remember in first if the next char needs to capitalized *)
	first := char = BYTE#32;
END_FOR;

(* revision histroy
hm		4. mar 2008	rev 1.0
	original release

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
