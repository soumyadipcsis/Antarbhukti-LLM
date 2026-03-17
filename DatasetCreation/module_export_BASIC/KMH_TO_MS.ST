(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	6 jan 2007
programmer 	hugo
tested by	tobias

this function converts velocities from Kilometers / hour to Meters / Second
(*@KEY@:END_DESCRIPTION*)
FUNCTION KMH_TO_MS:REAL

(*Group:Default*)


VAR_INPUT
	KMH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: KMH_TO_MS
IEC_LANGUAGE: ST
*)
KMH_TO_MS := kmh * 0.2777777777777;

(* revision history
hm	4. feb 2007		rev 1.0
	original version

hm	6. jan 2008		rev 1.1
	improved performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
