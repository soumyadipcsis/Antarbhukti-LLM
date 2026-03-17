(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.4	7. oct. 2008
programmer 	hugo
tested by	tobias

calculates the weekday of a week according to ISO8601   
monday = 1 ..... sunday = 7
(*@KEY@:END_DESCRIPTION*)
FUNCTION DAY_OF_WEEK:INT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DAY_OF_WEEK
IEC_LANGUAGE: ST
*)
DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;

(* revision history
hm 	21.8.06 		rev 1.1
	corrected a miscalculation

hm	23.12.2007		rev 1.2
	correction for step7

hm	7. apr. 2008	rev 1.3
	deleted unused step7 code

hm	7. oct. 2008	rev 1.4
	changed name of function from weekday to day_of_week

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
