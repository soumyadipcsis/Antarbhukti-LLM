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

this function calculates the arcus cosinus function of a complex number
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CACOS

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CACOS :	oscat_complex;
END_VAR


VAR
	Y :	oscat_complex;
	CACOSH :	CACOSH;
END_VAR


(*@KEY@: WORKSHEET
NAME: CACOS
IEC_LANGUAGE: ST
*)
CACOSH(X:=x);
y := CACOSH.CACOSH;
CACOS.re := y.im;
CACOS.im := -y.re;

(* revision history
hm	21. feb 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
