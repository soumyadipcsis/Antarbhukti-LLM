(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	27. mar. 2009
programmer 	hugo
tested by	oscat

returs the total days of the year.
the function retruns 366 for leap years and 365 otherwise.
the function works for dates from 1970 - 2099
(*@KEY@:END_DESCRIPTION*)
FUNCTION DAYS_IN_YEAR:INT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DAYS_IN_YEAR
IEC_LANGUAGE: ST
*)
IF LEAP_OF_DATE(IDATE) THEN
	DAYS_IN_YEAR := 366;
ELSE
	DAYS_IN_YEAR := 365;
END_IF;

(* revision history
hm	27. mar. 2009		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
