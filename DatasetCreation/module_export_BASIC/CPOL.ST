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

this function creates a complex numbers for the polar form with the inputs L (length) an A for Angle.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CPOL

(*Group:Default*)


VAR_INPUT
	L :	REAL;
	A :	REAL;
END_VAR


VAR_OUTPUT
	CPOL :	oscat_complex;
END_VAR


(*@KEY@: WORKSHEET
NAME: CPOL
IEC_LANGUAGE: ST
*)
CPOL.re := L * COS(A);
CPOL.im := L * SIN(A);

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
