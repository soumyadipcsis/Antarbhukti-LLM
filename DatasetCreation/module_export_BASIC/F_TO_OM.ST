(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. oct. 2008
programmer 	hugo
tested by	oscat

this function converts frequency to Omega F
Omega = 2*PI*F
(*@KEY@:END_DESCRIPTION*)
FUNCTION F_TO_OM:REAL

(*Group:Default*)


VAR_INPUT
	F :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_TO_OM
IEC_LANGUAGE: ST
*)
F_to_OM := 6.283185307179586476 * F;

(* revision history
hm	22. jan. 2007	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	unsing math constants

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
