(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	15. jun. 2008
programmer 	hugo
tested by	oscat

returns the date for the first day of the current month in the current year.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MONTH_BEGIN:UDINT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MONTH_BEGIN
IEC_LANGUAGE: ST
*)
MONTH_BEGIN := idate - _INT_TO_UDINT(DAY_OF_MONTH(idate) - 1) * UDINT#86400;

(* revision history
hm	15. JUN: 2008	rev 1.0
	original version	


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
