(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.GEOMETRY
*)
(*@KEY@:DESCRIPTION*)
version 1.1	4 dec 2007
programmer 	hugo
tested by	tobias

cone_V calculates the Volume of a cone
(*@KEY@:END_DESCRIPTION*)
FUNCTION CONE_V:REAL

(*Group:Default*)


VAR_INPUT
	RX :	REAL;
	HX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CONE_V
IEC_LANGUAGE: ST
*)
cone_V := 1.047197551 * RX * RX * hx;

(* revision histroy
hm	17. oct 2007	rev 1.0
	original version

hm	4. dec 2007		rev 1.1
	changed code for better performance

hm	22. feb 2008	rev 1.2
	changed code for better performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
