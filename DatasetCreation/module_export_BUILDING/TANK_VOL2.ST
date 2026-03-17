(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.0	10. Mar 2010
programmer 	hugo
tested by	tobias

TANK_VOL2 calculates the volume of a spherical tank filled to level H.
(*@KEY@:END_DESCRIPTION*)
FUNCTION TANK_VOL2:REAL

(*Group:Default*)


VAR_INPUT
	TR :	REAL;
	H :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TANK_VOL2
IEC_LANGUAGE: ST
*)
TANK_VOL2 := 3.14159265358979323846264338327950288 * H * H * (TR - H / 3.0);

(* revision histroy
hm	10. mar 2010	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
