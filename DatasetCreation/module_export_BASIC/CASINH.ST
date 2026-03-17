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

this function calculates the hyperbolic arcus sinus function of a complex number
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CASINH

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CASINH :	oscat_complex;
END_VAR


VAR
	Y :	oscat_complex;
	CLOG :	CLOG;
	CSQRT :	CSQRT;
END_VAR


(*@KEY@: WORKSHEET
NAME: CASINH
IEC_LANGUAGE: ST
*)
y.re := (X.re - X.im)*(X.re + X.im) + 1.0;
y.im := 2.0 * X.re * X.im;
CSQRT(X:=y);
y    := CSQRT.CSQRT;
y.re := y.re + x.re;
y.im := y.im + x.im;
CLOG(X:=y);
CASINH  := CLOG.CLOG;

(* revision history
hm	21. feb 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
