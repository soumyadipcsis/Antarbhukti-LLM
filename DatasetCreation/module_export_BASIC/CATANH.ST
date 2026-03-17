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

this function calculates the complex arcus hyperbolic tangens
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CATANH

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CATANH :	oscat_complex;
END_VAR


VAR
	i2 :	REAL;
	num :	REAL;
	den :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CATANH
IEC_LANGUAGE: ST
*)
i2 := x.im * x.im;
num := 1.0 + x.re;
num := i2 + num * num;
den := 1.0 - x.re;
den := i2 + den * den;
CATANH.re := 0.25 * (LN(num) - LN(den));
den := 1.0 - x.re * x.re - i2;
CATANH.im := 0.5 * ATAN(2.0 * x.im / den);

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
