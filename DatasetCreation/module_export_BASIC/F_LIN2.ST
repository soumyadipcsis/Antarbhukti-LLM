(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	1 jan 2007
programmer 	hugo
tested by	tobias

this function calculates the linear equation f_lin = a*x + b given by two points x1/y1 and x2/y2.
(*@KEY@:END_DESCRIPTION*)
FUNCTION F_LIN2:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	X1 :	REAL;
	Y1 :	REAL;
	X2 :	REAL;
	Y2 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_LIN2
IEC_LANGUAGE: ST
*)
F_LIN2 := (Y2 - Y1) / (X2 - X1) * (X - X1) + Y1;

(* revision history
hm	1. jan. 2007	rev 1.0
	original release

hm	17. dec. 2008	rev 1.1
	optimized formula

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
