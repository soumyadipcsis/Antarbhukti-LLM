(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	tobias

this function converts celsius  to fahrenheit 
(*@KEY@:END_DESCRIPTION*)
FUNCTION C_TO_F:REAL

(*Group:Default*)


VAR_INPUT
	CELSIUS :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: C_TO_F
IEC_LANGUAGE: ST
*)
C_TO_F := celsius * 1.8 + 32.0;


(* revision history

hm	4. aug. 2006	rev 1.0
	original version

hm	11. mar. 2009	rev 1.1
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
