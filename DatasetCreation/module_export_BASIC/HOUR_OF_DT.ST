(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	6. jun. 2008
programmer 	oscat
tested BY	oscat

HOUR_OF_DT returns the current hour (hour of the day) of a DT variable
(*@KEY@:END_DESCRIPTION*)
FUNCTION HOUR_OF_DT:INT

(*Group:Default*)


VAR_INPUT
	XDT :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: HOUR_OF_DT
IEC_LANGUAGE: ST
*)
HOUR_OF_DT := UDINT_TO_INT((XDT MOD UDINT#86400) / UDINT#3600);

(* revision history
hm		6.9.2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
