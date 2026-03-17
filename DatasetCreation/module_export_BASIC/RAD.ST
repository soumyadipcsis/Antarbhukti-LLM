(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	18. oct. 2008
programmer 	hugo
tested by	tobias

this function converts Radiant to degrees
(*@KEY@:END_DESCRIPTION*)
FUNCTION RAD:REAL

(*Group:Default*)


VAR_INPUT
	DEG :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: RAD
IEC_LANGUAGE: ST
*)
Rad := modR(0.0174532925199433 * deg , 6.283185307179586476);

(* revision history
hm	4. aug 2006		rev 1.0
	original version

hm 	16. oct 2007	rev 1.1
	added modr statement which prohibits rad to become bigger than 2PI

hm	18. oct 2008	rev 1.2
	using math constants

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
