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
tested by		tobias

this function converts celsius to kelvin
(*@KEY@:END_DESCRIPTION*)
FUNCTION C_TO_K:REAL

(*Group:Default*)


VAR_INPUT
	CELSIUS :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: C_TO_K
IEC_LANGUAGE: ST
*)
C_to_K := Celsius - 273.15;

(* revision history

hm	4. aug 2006	rev 1.0
	original version

hm	19. aug 2009	rev 1.1
	fixed calculation error

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
