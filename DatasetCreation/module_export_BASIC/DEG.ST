(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. mar. 2009
programmer 	hugo
tested by	tobias

this function converts degrees into Radiant
execution time on wago 750 - 841 =  10  us
(*@KEY@:END_DESCRIPTION*)
FUNCTION DEG:REAL

(*Group:Default*)


VAR_INPUT
	RAD :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEG
IEC_LANGUAGE: ST
*)
DEG := MODR(57.29577951308232 * RAD, 360.0);

(* revision history
hm	4. aug 2006	rev 1.0
	original version

hm 16. oct 2007	rev 1.1
	added modr statement which prohibits deg to become bigger than 360

hm	10. mar. 2009	rev 1.2
	real constants updated to new systax using dot
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
