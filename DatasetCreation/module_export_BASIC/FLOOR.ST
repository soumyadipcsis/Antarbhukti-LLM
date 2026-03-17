(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	21. mar. 2008
programmer 	hugo
tested by	tobias

This is a rounding function which returns the biggest possible integer which is less or equal to X.
floor(3.14) = 3
floor(-3.14) = -4
(*@KEY@:END_DESCRIPTION*)
FUNCTION FLOOR:INT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FLOOR
IEC_LANGUAGE: ST
*)
FLOOR := REAL_TO_INT(X);
IF INT_TO_REAL(FLOOR) > X THEN
	floor := floor - 1;
END_IF;

(* revision history
hm		7. feb 2007		rev 1.0
	originlal version

hm		21. mar. 2008	rev 1.1
	replaced trunc with real_to_int for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
