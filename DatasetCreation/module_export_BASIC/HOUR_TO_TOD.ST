(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	14 aug 2008
programmer 	hugo
tested by	tobias

converts an amount of hours in real to time of day TOD.
(*@KEY@:END_DESCRIPTION*)
FUNCTION HOUR_TO_TOD:UDINT

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HOUR_TO_TOD
IEC_LANGUAGE: ST
*)
hour_to_tod := _REAL_TO_UDINT(IN * 3600000.00);

(* revision history
hm		4. aug 2006	rev 1.0
	original version

hm		14. mar 2008	rev 1.1
	rounded the input after the last digit

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
