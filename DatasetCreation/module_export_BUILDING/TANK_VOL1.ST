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

TANK_VOL1 calculates the volume of a tubular tank filled to level H.
(*@KEY@:END_DESCRIPTION*)
FUNCTION TANK_VOL1:REAL

(*Group:Default*)


VAR_INPUT
	TR :	REAL;
	TL :	REAL;
	H :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TANK_VOL1
IEC_LANGUAGE: ST
*)
TANK_VOL1 := CIRCLE_SEG(TR, H) * TL;

(* revision histroy
hm	10. mar 2010	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
