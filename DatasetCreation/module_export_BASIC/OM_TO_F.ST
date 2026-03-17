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
tested by		tobias

this function converts Omega F to frequency
F = OM / (2*PI)
(*@KEY@:END_DESCRIPTION*)
FUNCTION OM_TO_F:REAL

(*Group:Default*)


VAR_INPUT
	OM :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: OM_TO_F
IEC_LANGUAGE: ST
*)
OM_to_F := OM / 6.283185307179586476;

(* revision history
hm	22. jan. 2007	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	using math constants

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
