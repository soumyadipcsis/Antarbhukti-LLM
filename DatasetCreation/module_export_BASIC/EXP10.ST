(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	 2 dec 2007
programmer 	hugo
tested by	tobias

this function calculates the exponent to the basis 10
exp10(3) = 1000
(*@KEY@:END_DESCRIPTION*)
FUNCTION EXP10:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: EXP10
IEC_LANGUAGE: ST
*)
exp10 := EXP(X * 2.30258509299405);

(* revision history
hm	2. dec 2007		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
