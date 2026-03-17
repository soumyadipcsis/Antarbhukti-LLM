(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	29. mar. 2008
programmer 	hugo
tested by	tobias

the function fix truncates a string at length L 
or if the string is shorter then L it will be filled with ending Spaces till its length = N.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FIX

(*Group:Default*)


VAR_INPUT
	STR :	oscat_STRING250;
	L :	INT;
	C :	BYTE;
	M :	INT;
END_VAR


VAR_OUTPUT
	FIX :	oscat_STRING250;
END_VAR


VAR
	N :	INT;
	FILL :	FILL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIX
IEC_LANGUAGE: ST
*)
(* make sure L does not exceed the limits of a string *)
N := LIMIT(0,L,255) - LEN(str);
IF N <= 0 THEN
	(* truncate the string at length N *)
	IF M = 1 THEN
		FIX := RIGHT(str,L);
	ELSE
		FIX := LEFT(str,L);
	END_IF;
ELSIF M = 1 THEN
	(* connect fill characters at the beginning *)
    FILL(C:=C,L:=N);
	FIX := CONCAT(FILL.FILL,str);
ELSIF M = 2 THEN
	(* center str beween fill characters *)
	(* for an uneven number of fill characters, there is one more at the end *)
    FILL(C:=C,L:=_BYTE_TO_INT(SHR_BYTE(INT_TO_BYTE(N+1),1)));
	FIX := CONCAT(str,FILL.FILL);
    FILL(C:=C,L:=_BYTE_TO_INT(SHR_BYTE(INT_TO_BYTE(N),1)));
	FIX := CONCAT(FILL.FILL,FIX);
ELSE
	(* connect fill characters at the end *)
    FILL(C:=C,L:=N);
	FIX := CONCAT(str,FILL.FILL);
END_IF;

(* revision histroy
hm	29. mar. 2008	rev 1.0
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
