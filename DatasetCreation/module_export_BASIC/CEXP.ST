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

this function calculates the complex exponent
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CEXP

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CEXP :	oscat_complex;
END_VAR


VAR
	Temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CEXP
IEC_LANGUAGE: ST
*)
temp := EXP(X.re);
CEXP.re := temp * COS(X.im);
CEXP.im := temp * SIN(X.im);

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
