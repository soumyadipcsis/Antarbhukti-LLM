(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	28. jan. 2011
programmer 	hugo
tested by	tobias

leap_of_date is true if current year is a leap year  
(*@KEY@:END_DESCRIPTION*)
FUNCTION LEAP_OF_DATE:BOOL

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LEAP_OF_DATE
IEC_LANGUAGE: ST
*)
LEAP_OF_DATE := SHL(UDINT_TO_DWORD((idate + UDINT#43200) / UDINT#31557600), 30) = DWORD#16#80000000;

(* change history

2.10.2006		rev 1.1
the function now calls leap_year to accomodate further accuracy.
the function now works for any year from 1970 to 2100

8. jan 2008		rev 1.2
	improved code for better performance

28. jan. 2011	rev 1.3
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
