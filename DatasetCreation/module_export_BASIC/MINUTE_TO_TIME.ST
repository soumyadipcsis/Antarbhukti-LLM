(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	24. feb. 2009
programmer 	hugo
tested by	oscat

converts an amount of minutes in real to time
(*@KEY@:END_DESCRIPTION*)
FUNCTION MINUTE_TO_TIME:TIME

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MINUTE_TO_TIME
IEC_LANGUAGE: ST
*)
minute_to_time := UDINT_TO_TIME(_REAL_TO_UDINT(IN * 60000.0));

(* revision history
hm		4. aug 2006	rev 1.0
	original version

hm		14. mar 2008	rev 1.1
	rounded the input after the last digit

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
