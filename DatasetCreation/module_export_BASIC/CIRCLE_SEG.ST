(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.GEOMETRY
*)
(*@KEY@:DESCRIPTION*)
version 1.0	10. Mar 2010
programmer 	hugo
tested by	tobias

CIRCLE_SEG calculates the Area of a circle segement enclosed between a sectant line and the circumference.

(*@KEY@:END_DESCRIPTION*)
FUNCTION CIRCLE_SEG:REAL

(*Group:Default*)


VAR_INPUT
	RX :	REAL;
	HX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CIRCLE_SEG
IEC_LANGUAGE: ST
*)
IF RX > 0.0 THEN
	CIRCLE_SEG := 2.0 * ACOS(1.0 - LIMIT(0.0, HX / RX, 2.0));
	CIRCLE_SEG := (CIRCLE_SEG - SIN(CIRCLE_SEG)) * RX * RX * 0.5;
END_IF;

(* revision histroy
hm	10. mar 2010	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
