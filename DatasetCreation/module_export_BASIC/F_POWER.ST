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

this function calculates the power equation f_power = a*x^n
(*@KEY@:END_DESCRIPTION*)
FUNCTION F_POWER:REAL

(*Group:Default*)


VAR_INPUT
	A :	REAL;
	X :	REAL;
	N :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_POWER
IEC_LANGUAGE: ST
*)
f_power := a * EXPT(X,N);
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
