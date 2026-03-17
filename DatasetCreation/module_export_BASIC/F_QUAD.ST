(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. Mar. 2011
programmer 	hugo
tested by	tobias

this function calculates the quadratic equation f_lin = a*x + b
(*@KEY@:END_DESCRIPTION*)
FUNCTION F_QUAD:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	A :	REAL;
	B :	REAL;
	C :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_QUAD
IEC_LANGUAGE: ST
*)
F_QUAD :=  (A * X + B) * X + C;

(* revision history

hm	1. sep. 2006	rev 1.0
	original version

hm	18. mar. 2001	rev 1.1
	improved performance
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
