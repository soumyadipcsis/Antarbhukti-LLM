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

this function add two complex numbers
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CADD

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
	Y :	oscat_complex;
END_VAR


VAR_OUTPUT
	CADD :	oscat_complex;
END_VAR


(*@KEY@: WORKSHEET
NAME: CADD
IEC_LANGUAGE: ST
*)
CADD.re := x.re + y.re;
CADD.im := x.im + y.im;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
