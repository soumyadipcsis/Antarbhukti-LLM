(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	26. oct. 2008
programmer 	hugo
tested by	tobias

This function returns -X
(*@KEY@:END_DESCRIPTION*)
FUNCTION NEGX:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: NEGX
IEC_LANGUAGE: ST
*)
NEGX := -X;

(* revision history
hm	26. oct. 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
