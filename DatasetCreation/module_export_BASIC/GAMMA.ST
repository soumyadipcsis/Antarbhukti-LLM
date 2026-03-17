(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	hugo
tested by	oscat

this function calculates the stirling function which is an approximation for the gamma function

(*@KEY@:END_DESCRIPTION*)
FUNCTION GAMMA:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: GAMMA
IEC_LANGUAGE: ST
*)
IF x > 0.0 THEN
	GAMMA := SQRT(6.28318530717958647692528676655900576 / X) * EXPT(0.367879441171442 * (x + 1.0 / (12.0 * x - 0.1 / X)), X);
END_IF;


(* the stirling formula is not very accurate for small values of X
IF X >=0 THEN GAMMA := SQRT(math.PI2 * X) * EXPT(X / math.E, X); END_IF;
*)


(* revision history
hm	10.12.2007	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	using math constants

hm	26. oct. 2008	rev 1.2
	using new formula with better accuracy

hm	10. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
