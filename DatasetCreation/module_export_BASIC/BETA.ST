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
tested by	oscat

this function calculates the beta function for real number > 0.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BETA:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	Y :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: BETA
IEC_LANGUAGE: ST
*)
BETA := GAMMA(X)*GAMMA(Y) / GAMMA(x+y);

(* revision history
hm	26. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
