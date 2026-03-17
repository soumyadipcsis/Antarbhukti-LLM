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

this function calculates the complex sqare root
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CSQRT

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CSQRT :	oscat_complex;
END_VAR


VAR
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CSQRT
IEC_LANGUAGE: ST
*)
temp := HYPOT(x.re, x.im);
CSQRT.re :=  SQRT(0.5 * (temp + x.re));
CSQRT.im :=  INT_TO_REAL(sgn(x.im)) * SQRT(0.5 * (temp - x.re));

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
