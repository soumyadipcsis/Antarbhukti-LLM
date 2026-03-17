(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	9. oct. 2008
programmer 	hugo
tested by	oscat

TIMER_P4 is a programmable universal timer.
(*@KEY@:END_DESCRIPTION*)
FUNCTION DAY_OF_DATE:DINT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DAY_OF_DATE
IEC_LANGUAGE: ST
*)
day_of_date := UDINT_TO_DINT(idate / UDINT#86400);

(* revision history
hm		16.9.2007		rev 1.0
	original version

hm		1. okt 2007		rev 1.1
	added step7 compatibility

hm		22. mar. 2008	rev 1.2
	changed output from int to Dint because the total date range is 49710 days

hm		7. apr. 2008	rev 1.3
	deleted unused step7 code

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
