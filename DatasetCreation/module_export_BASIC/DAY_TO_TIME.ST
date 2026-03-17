(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	24. feb. 2009
programmer 	hugo
tested by	tobias

converts an amount of days in real to time
(*@KEY@:END_DESCRIPTION*)
FUNCTION DAY_TO_TIME:TIME

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DAY_TO_TIME
IEC_LANGUAGE: ST
*)
day_to_time := DINT_TO_TIME(UDINT_TO_DINT(_REAL_TO_UDINT(IN * REAL#86400000.00)));

(* revision history
hm	4. aug. 2006	rev 1.0
	original release

hm	24. feb. 2009	rev 1.1
	renamed input to IN
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
