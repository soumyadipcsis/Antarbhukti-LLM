(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	7 feb 2007
programmer 	hugo
tested by	tobias

This is a rounding function which returns the smallest possible integer which is greater or equal to X.
ceil(3.14) = 4
ceil(-3.14) = -3
(*@KEY@:END_DESCRIPTION*)
FUNCTION CEIL:INT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CEIL
IEC_LANGUAGE: ST
*)
CEIL := REAL_TO_INT(x);
IF INT_TO_REAL(CEIL) < X THEN
        CEIL := CEIL + 1;
END_IF;

(* code before rev 1.1
CEIL := D_TRUNC(X);
IF CEIL < X THEN
	ceil := ceil + 1;
END_IF;
*)

(* revision history
hm		7. feb. 2007	rev 1.0
	original version

hm		21. mar. 2008	rev 1.1
	use REAL_TO_INT instead of trunc for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
