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

this function calculates the Cauchy distribution function
(*@KEY@:END_DESCRIPTION*)
FUNCTION CAUCHYCD:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	T :	REAL;
	U :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CAUCHYCD
IEC_LANGUAGE: ST
*)
CAUCHYCD := 0.5 + 0.318309886183791 * ATAN((X - T) / U);



(* revision hisdtory
hm	26. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
