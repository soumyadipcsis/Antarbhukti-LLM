(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21 feb 2008
programmer 	hugo
tested by	oscat

this function calculates the pythagorean function
es the arcus cos hyperbolicus
(*@KEY@:END_DESCRIPTION*)
FUNCTION HYPOT:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	Y :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HYPOT
IEC_LANGUAGE: ST
*)
HYPOT := SQRT(x*x + y*y);

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
