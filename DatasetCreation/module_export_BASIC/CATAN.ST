(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.COMPLEX
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21 feb 2008
programmer 	hugo
tested by	oscat

this function calculates the complex arcus tangens
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CATAN

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CATAN :	oscat_complex;
END_VAR


VAR
	r2 :	REAL;
	num :	REAL;
	den :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CATAN
IEC_LANGUAGE: ST
*)
r2 := x.re * x.re;
den := 1.0 - r2 - x.im * x.im;
CATAN.re := 0.5 * ATAN(2.0 * x.re / den);
num := x.im + 1.0;
num := r2 + num * num;
den := x.im - 1.0;
den := r2 + den * den;
CATAN.im := 0.25 * (LN(num)-LN(den));

(* revision history
hm	21. feb 2008	rev 1.0
	original version
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
