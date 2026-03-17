(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	30. sep. 2008
programmer 	hugo
tested by	oscat

DEC_TO_INT converts a decimal string into an Integer.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DEC_TO_INT

(*Group:Default*)


VAR_INPUT
	DEC :	oscat_STRING10;
END_VAR


VAR_OUTPUT
	DEC_TO_INT :	INT;
END_VAR


VAR
	i :	INT;
	X :	INT;
	sign :	BOOL;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEC_TO_INT
IEC_LANGUAGE: ST
*)
DEC_TO_INT := 0;
sign := FALSE;
stop := LEN(dec);
FOR I := 1 TO stop DO
	(* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    X := GET_CHAR(DEC,I);
	(* calculate the value of the digit *)
	IF X > 47 AND X < 58 THEN
		DEC_TO_INT := DEC_TO_INT * 10 + X - 48;
	ELSIF X = 45 AND DEC_TO_INT = 0 THEN
		sign := TRUE;
	END_IF;
END_FOR;
IF sign THEN DEC_TO_INT := -DEC_TO_INT; END_IF;

(* revision histroy
hm	20. jun. 2008	rev 1.0
	original release

hm	30. sep. 2008	rev 1.1
	changed length of input string from 20 to 10
	corrected an error where decoding of characters 8 and 9 would fail
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
