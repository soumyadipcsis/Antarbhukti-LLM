(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. sep. 2008
programmer 	hugo
tested by	oscat

OCT_TO_BYTE converts a octagonal string into a byte.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK OCT_TO_BYTE

(*Group:Default*)


VAR_INPUT
	OCT :	oscat_STRING10;
END_VAR


VAR_OUTPUT
	OCT_TO_BYTE :	BYTE;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	X :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: OCT_TO_BYTE
IEC_LANGUAGE: ST
*)
OCT_TO_BYTE := BYTE#0;
stop := LEN(oct);
FOR I := 1 TO stop DO
	(* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    X := GET_CHAR(oct,I);
	(* calculate the value of the digit *)
	IF X > 47 AND x < 56 THEN
	    OCT_TO_BYTE := SHL_BYTE(OCT_TO_BYTE,3) OR INT_TO_BYTE(X - 48);
	END_IF;
END_FOR;

(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	20. sep. 2008	rev 1.1
	changed length of input string from 20 to 10

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
