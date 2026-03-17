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
tested by	oscat

returs the year of a date  
the function works for dates from 1970 - 2099
(*@KEY@:END_DESCRIPTION*)
FUNCTION YEAR_OF_DATE:INT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: YEAR_OF_DATE
IEC_LANGUAGE: ST
*)
YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);

(* code used prior to rev 1.1
year := DWORD_TO_INT((DATE_TO_DWORD(idate)/864+71954300)/36525);
*)

(* revision history
hm	4. aug 2006		rev 1.0
	original version

hm	1. okt 2007		rev 1.1
	corrected error in algorithm
	adjustment for S7 compatibility

hm	23.12.2007		rev 1.2
	changed code for better performance

hm	7. apr. 2008	rev 1.3
	deleted unused step7 code

hm	7. oct. 2008	rev 1.4
	reneamed function (year) to year_of_date

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
