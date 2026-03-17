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

this function calculates the arcus sinus function of a complex number
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CASIN

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CASIN :	oscat_complex;
END_VAR


VAR
	Y :	oscat_complex;
	CASINH :	CASINH;
END_VAR


(*@KEY@: WORKSHEET
NAME: CASIN
IEC_LANGUAGE: ST
*)
y.re := -x.im;
y.im := x.re;
CASINH(X:=y);
y := CASINH.CASINH;
CASIN.re := y.im;
CASIN.im := -y.re;

(* revision history
hm	21. feb 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
