(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.GEOMETRY
*)
(*@KEY@:DESCRIPTION*)
version 1.1	22 feb 2008
programmer 	hugo
tested by	tobias

circle_C calculates the Circumference of a circle  if ax = 360 the whole circle is calculated
(*@KEY@:END_DESCRIPTION*)
FUNCTION CIRCLE_C:REAL

(*Group:Default*)


VAR_INPUT
	RX :	REAL;
	AX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CIRCLE_C
IEC_LANGUAGE: ST
*)
circle_C := 1.7453293E-2 * Rx * Ax;

(* revision histroy
hm	16. oct 2007	rev 1.0
	original version

hm	22. feb 2008	rev 1.1
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
