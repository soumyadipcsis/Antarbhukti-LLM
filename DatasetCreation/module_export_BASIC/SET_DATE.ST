(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 2.3	29. dec. 2011
programmer 	hugo
tested by	tobias

creates a date output from year, month and day of month

(*@KEY@:END_DESCRIPTION*)
FUNCTION SET_DATE:UDINT

(*Group:default*)


VAR_INPUT
	YEAR :	INT;
	MONTH :	INT;
	DAY :	INT;
END_VAR


VAR
	count :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SET_DATE
IEC_LANGUAGE: ST
*)
IF month > 2 THEN
	count := (month - 1) * 30;
	IF month > 7 THEN
		count := count + DWORD_TO_INT(SHR_DWORD(DINT_TO_DWORD(INT_TO_DINT(month) - INT_TO_DINT(3)),1));
	ELSE
		count := count + DWORD_TO_INT(SHR_DWORD(DINT_TO_DWORD(INT_TO_DINT(month) - INT_TO_DINT(4)),1));
	END_IF;
	(* chech for leap year and add one day if true *)
	IF SHL_WORD(INT_TO_WORD(year),14) = WORD#0 THEN
		count := count + 1;
	END_IF;
ELSE
	count := (month - 1) * 31;
END_IF;
SET_DATE := (_INT_TO_UDINT(count + day - 1) + DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(year) * UDINT#1461 - UDINT#2878169), 2))) * UDINT#86400;

(* revision history
hm	4. aug. 2006	rev 1.0
	original version

hm	19 sep. 2007	rev 1.1
	use function leap_year to calculate leap year, more exceptions are handled

hm	1. okt	2007	rev 1.2
	added compatibility to step7

hm	16.dec 2007		rev 1.3
	changed code to improove performance

hm	3. jan. 2008	rev 1.4
	further improvements in performance

hm	16. mar. 2008	rev 1.5
	added type conversions to avoid warnings under codesys 3.0

hm	7. apr. 2008	rev 1.6
	deleted unused step7 code

hm	14. oct. 2008	rev 1.7
	optimized code for better performance

hm	25. oct. 2008	rev 2.0
	new code using setup constants

hm	16. nov. 2008	rev 2.1
	added typecasts to avoid warnings

hm	22. jan. 2011	rev 2.2
	improved performance

hm	29. dec. 2011	rev 2.3
	improved performance
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION
