(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.GEOMETRY
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. oct. 2008
programmer 	hugo
tested by	oscat

ellipse_A calculates the Area of an ellipe based on the two radians R1 and R2
(*@KEY@:END_DESCRIPTION*)
FUNCTION ELLIPSE_A:REAL

(*Group:Default*)


VAR_INPUT
	R1 :	REAL;
	R2 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ELLIPSE_A
IEC_LANGUAGE: ST
*)
ellipse_A := 3.14159265358979323846264338327950288 * R1 * R2;

(* revision histroy
hm	16. oct 2007	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	using math constants
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
