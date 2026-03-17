(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	19. aug 2009
programmer 	hugo
tested by	tobias

this function converts kelvin to celsius
(*@KEY@:END_DESCRIPTION*)
FUNCTION K_TO_C:REAL

(*Group:Default*)


VAR_INPUT
	KELVIN :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: K_TO_C
IEC_LANGUAGE: ST
*)
K_to_C := Kelvin + 273.15;

(* revision history

hm	4. aug 2006	rev 1.0
	original version

hm	19. aug 2009	rev 1.1
	fixed calculation error

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
