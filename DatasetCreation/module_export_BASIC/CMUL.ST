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

this function multiplies two complex numbers
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CMUL

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
	Y :	oscat_complex;
END_VAR


VAR_OUTPUT
	CMUL :	oscat_complex;
END_VAR


(*@KEY@: WORKSHEET
NAME: CMUL
IEC_LANGUAGE: ST
*)
CMUL.re := X.re * Y.re - X.im * Y.im;
CMUL.im := X.re * Y.im + X.im * Y.re;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
