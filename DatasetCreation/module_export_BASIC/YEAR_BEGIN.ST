(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	7. Apr. 2008
programmer 	hugo
tested by	tobias

returs the date of january 1st for the given year  
the function works for dates from 1970 - 2099
(*@KEY@:END_DESCRIPTION*)
FUNCTION YEAR_BEGIN:UDINT

(*Group:Default*)


VAR_INPUT
	Y :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: YEAR_BEGIN
IEC_LANGUAGE: ST
*)
year_begin := DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(y) * UDINT#1461 - UDINT#2878169),2))  *  UDINT#86400;

(* revision history
hm	19. dec 2007	rev 1.0
	original version

hm	4. jan 2008		rev 1.1
	formula for step7 was incorrect during leap years

hm	7. apr. 2008	rev 1.2
	deleted unused step7 code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
