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

this function divides two complex numbers
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CDIV

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
	Y :	oscat_complex;
END_VAR


VAR_OUTPUT
	CDIV :	oscat_complex;
END_VAR


VAR
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CDIV
IEC_LANGUAGE: ST
*)
temp := Y.re * Y.re + Y.im * Y.im;
IF temp = 0.0 THEN CDIV.re := 0.0;CDIV.im := 0.0;RETURN;END_IF;
CDIV.re := (X.re * Y.re + X.im * Y.im) / temp;
CDIV.im := (X.im * Y.re - X.re * Y.im) / temp;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
