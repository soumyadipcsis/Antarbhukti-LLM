(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	2 okt 2006
programmer 	hugo
tested by	tobias

extracts the hour of a Time_of_day
(*@KEY@:END_DESCRIPTION*)
FUNCTION HOUR:INT

(*Group:Default*)


VAR_INPUT
	ITOD :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: HOUR
IEC_LANGUAGE: ST
*)
hour := UDINT_TO_INT(itod / UDINT#3600000);

(* change history
hm 4. aug 2006	rev 1.0
	original version

hm 2.10.2006 	rev 1.1
	changed name of input to itod

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
