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

this function calculates the sinus function of a complex number
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CSINH

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CSINH :	oscat_complex;
END_VAR


(*@KEY@: WORKSHEET
NAME: CSINH
IEC_LANGUAGE: ST
*)
CSINH.re := sinH(X.re) * COS(X.im);
CSINH.im := cosH(X.re) * SIN(X.im);

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
