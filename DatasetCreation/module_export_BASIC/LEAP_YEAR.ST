(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	2 oct 2006
programmer 	hugo
tested by	tobias

leap_year is true if the tested year is a leap year
(*@KEY@:END_DESCRIPTION*)
FUNCTION LEAP_YEAR:BOOL

(*Group:Default*)


VAR_INPUT
	YEAR :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LEAP_YEAR
IEC_LANGUAGE: ST
*)
IF (year MOD INT#400) = INT#00 THEN
  leap_year := TRUE;
ELSIF (year MOD INT#100) = INT#00 THEN
  leap_year := FALSE;
ELSIF (year MOD INT#04) = INT#00 THEN
  leap_year := TRUE;
ELSE
  leap_year := FALSE;
END_IF;

(* change history

hm 	2.10.2006		rev 1.1
	the function now works for any year from 1970 up to 2100

hm	1. oct 2007		rev 1.2
	chaged code for higher performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
