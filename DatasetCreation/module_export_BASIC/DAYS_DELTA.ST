(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.3		25. jan. 2011
programmer 		hugo
tested by		tobias

days_delta calculates the days between two dates. the days are calculated date_2 - date_1.

(*@KEY@:END_DESCRIPTION*)
FUNCTION DAYS_DELTA:DINT

(*Group:Default*)


VAR_INPUT
	DATE_1 :	UDINT;
	DATE_2 :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DAYS_DELTA
IEC_LANGUAGE: ST
*)
IF DATE_1 > DATE_2 THEN
	DAYS_DELTA := - UDINT_TO_DINT((date_1 - date_2) / UDINT#86400);
ELSE
	DAYS_DELTA :=   UDINT_TO_DINT((date_2 - date_1) / UDINT#86400);
END_IF;

(* revision history
hm	27. dec 2006	rev 1.0
	original version

hm	16.9.2007		rev 1.1
	coorected an error in formula and changed algorithm to show positive and negative delta

hm	22. mar. 2008	rev 1.2
	changed output from int to dint because the total date range is 49710 days

hm	25. jan. 2011	rev 1.3
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
