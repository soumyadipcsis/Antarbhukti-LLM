(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	2. jun 2008
programmer 	hugo
tested by	tobias
(*@KEY@:END_DESCRIPTION*)
FUNCTION CTRL_IN:REAL

(*Group:Default*)


VAR_INPUT
	SET_POINT :	REAL;
	ACTUAL :	REAL;
	NOISE :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CTRL_IN
IEC_LANGUAGE: ST
*)
(* calculate the process error DIFF *)
CTRL_IN := DEAD_ZONE(SET_POINT - ACTUAL, NOISE);

(* revision history
hm 	2. jun. 2008 	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
