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

this function creates a complex number from two real inputs
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CSET

(*Group:Default*)


VAR_INPUT
	RE :	REAL;
	IM :	REAL;
END_VAR


VAR_OUTPUT
	CSET :	oscat_complex;
END_VAR


(*@KEY@: WORKSHEET
NAME: CSET
IEC_LANGUAGE: ST
*)
CSET.re := RE;
CSET.im := IM;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
