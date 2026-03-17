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
FUNCTION CAUCHY:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	T :	REAL;
	U :	REAL;
END_VAR


VAR
	tmp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CAUCHY
IEC_LANGUAGE: ST
*)
tmp := x - t;
CAUCHY := 0.318309886183791 * U / (U*U + tmp*tmp);



(* revision hisdtory
hm	26. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
