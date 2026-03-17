(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	4 Feb 2007
programmer 	hugo
tested by	tobias

this function converts velocities from Meters / Second to Kilometers / hour.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MS_TO_KMH:REAL

(*Group:Default*)


VAR_INPUT
	MS :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MS_TO_KMH
IEC_LANGUAGE: ST
*)
MS_TO_KMH := ms * 3.6;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
