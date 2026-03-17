(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	24. jan. 2011
programmer 	hugo
tested by	oscat

returs the date of december 31st for the given year  
the function works for dates from 1970 - 2099 

(*@KEY@:END_DESCRIPTION*)
FUNCTION YEAR_END:UDINT

(*Group:Default*)


VAR_INPUT
	Y :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: YEAR_END
IEC_LANGUAGE: ST
*)
YEAR_END := DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(INT_TO_UDINT(y) * UDINT#1461 - UDINT#2876712), 2)) * UDINT#86400;

(* revision history
hm	15. jun. 2008	rev 1.0
	original version

hm	24. jan 2011	rev 1.1
	improved performance
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
