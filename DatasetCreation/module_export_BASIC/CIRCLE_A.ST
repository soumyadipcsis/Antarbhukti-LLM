(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.GEOMETRY
*)
(*@KEY@:DESCRIPTION*)
version 1.2	22. feb 2008
programmer 	hugo
tested by	tobias

circle_A calculates the Area of a circle segement if ax = 360 the whole circle is calculated
(*@KEY@:END_DESCRIPTION*)
FUNCTION CIRCLE_A:REAL

(*Group:Default*)


VAR_INPUT
	RX :	REAL;
	AX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CIRCLE_A
IEC_LANGUAGE: ST
*)
circle_A := Rx * RX * 8.726646E-3 * Ax;

(* revision histroy
hm	16. oct 2007	rev 1.0
	original version

hm	4. dec 2007		rev 1.1
	changed code for better performance

hm	22. feb 2008	rev 1.2
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
