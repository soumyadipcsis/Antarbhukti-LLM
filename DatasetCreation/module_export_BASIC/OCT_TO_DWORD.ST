(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	18. jun 2008
programmer 	hugo
tested by	oscat

OCT_TO_DWORD converts a octagonal string into a dword.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK OCT_TO_DWORD

(*Group:Default*)


VAR_INPUT
	OCT :	oscat_STRING20;
END_VAR


VAR_OUTPUT
	OCT_TO_DWORD :	DWORD;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	X :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: OCT_TO_DWORD
IEC_LANGUAGE: ST
*)
OCT_TO_DWORD := DWORD#0;
stop := LEN(oct);
FOR I := 1 TO stop DO
	(* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    X := GET_CHAR(oct,I);
	(* calculate the value of the digit *)
	IF X > 47 AND x < 56 THEN
	    OCT_TO_DWORD := SHL_DWORD(OCT_TO_DWORD,3) OR INT_TO_DWORD(X - 48);
	END_IF;
END_FOR;


(* revision histroy
hm	2.10.2007		rev 1.0
	original release

hm	19.11.2007		rev 1.1
	changed type of function from int to dword

hm 	4. mar 2008		rev 1.2
	added support for a..f and return 0 for invalid string

hm	29. mar. 2008	rev 1.3
	changed STRING to STRING(8)

hm	18. jun. 2008	rev 1.4
	changed input hex to STRING(20)
	function now ignores wrong characters
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
