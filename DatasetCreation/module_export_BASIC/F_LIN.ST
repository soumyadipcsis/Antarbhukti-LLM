(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	1 sep 2006
programmer 	hugo
tested by	tobias

this function calculates the linear equation f_lin = a*x + b
(*@KEY@:END_DESCRIPTION*)
FUNCTION F_LIN:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	A :	REAL;
	B :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_LIN
IEC_LANGUAGE: ST
*)
F_lin := A * X + B;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
