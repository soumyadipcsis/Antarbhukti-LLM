(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.5	16 mar 2008
programmer 	hugo
tested by	tobias

creates a date output from year, month and day of month
year must be in the form of 4 digits ie 2006 or 1977.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SET_DT:UDINT

(*Group:Default*)


VAR_INPUT
	YEAR :	INT;
	MONTH :	INT;
	DAY :	INT;
	HOUR :	INT;
	MINUTE :	INT;
	SECOND :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SET_DT
IEC_LANGUAGE: ST
*)
SET_DT := SET_DATE(YEAR, MONTH, DAY) + _INT_TO_UDINT(SECOND) + _INT_TO_UDINT(MINUTE) * UDINT#60 + _INT_TO_UDINT(HOUR) * UDINT#3600;

(* revision history
hm	4. aug. 2006		rev 1.0
	original version

hm		19 sep. 2007	rev 1.1
	use function leap_year to calculate leap year, more exceptions are handled

hm		1. okt 2007		rev 1.2
	added step7 compatibility
	call function set_date

hm		8. oct 2007		rev 1.3
	deleted unused variables count and leap

hm		1. 11 2007		rev 1.4
	converted hour type integer to dword in calculation to avoid overrun on möller ecp4

hm		16. mar 2008	rev 1.5
	added type conversions to avoid warnings under codesys 3.0
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION
