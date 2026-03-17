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

this function calculates the inverse of a complex numbers (1 / X)
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CINV

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CINV :	oscat_complex;
END_VAR


VAR
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CINV
IEC_LANGUAGE: ST
*)
temp := X.re * X.re + X.im * X.im;
IF temp = 0.0 THEN CINV.re := 0.0;CINV.im := 0.0;RETURN;END_IF;
CINV.re := X.re / temp;
CINV.im := -X.im / temp;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
