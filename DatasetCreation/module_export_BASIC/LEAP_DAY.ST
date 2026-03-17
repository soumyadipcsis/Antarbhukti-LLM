(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	24. jan. 2011
programmer 	hugo
tested by	oscat

leap_day is true if the tested day is a leap day (29. of february).  
(*@KEY@:END_DESCRIPTION*)
FUNCTION LEAP_DAY:BOOL

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LEAP_DAY
IEC_LANGUAGE: ST
*)
LEAP_DAY := IDATE MOD UDINT#126230400 = UDINT#68169600;

(* change history

hm 	15. jun. 2008	rev 1.0
	original version

hm	7. oct. 2008	rev 1.1
	changed function month to month_of_date

hm	24. jan. 2011	rev 1.2
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
