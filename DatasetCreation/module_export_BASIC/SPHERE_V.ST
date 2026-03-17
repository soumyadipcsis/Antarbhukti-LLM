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

sphere_V calculates the Volume of a Sphere
(*@KEY@:END_DESCRIPTION*)
FUNCTION SPHERE_V:REAL

(*Group:Default*)


VAR_INPUT
	RX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SPHERE_V
IEC_LANGUAGE: ST
*)
sphere_V := 4.188790205 * Rx * RX * RX;

(* revision histroy
hm	16. oct 2007	rev 1.0
	original version

hm	4. dec 2007		rev 1.1
	changed code for better performance

hm	22. feb 2008		rev 1.2
	changed code for better performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
