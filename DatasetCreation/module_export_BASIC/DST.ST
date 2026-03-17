(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.5	24. jan. 2011
programmer 	hugo
tested by	oscat

this functions returns TRUE IF dst TIME is active 
the FUNCTION calculates automatically for any year betweek 1970 AND 2099 
wheather daylight savings is on OR off 
the summertime calculation is done according to european standards.
dst will become TRUE AT 01:00 utc in the morning FOR the respective days 
AND it will become FALSE after daylight savings TIME is switched back end OF october at 01:00 utc

(*@KEY@:END_DESCRIPTION*)
FUNCTION DST:BOOL

(*Group:Default*)


VAR_INPUT
	UTC :	UDINT;
END_VAR


VAR
	yr :	INT;
	yr4 :	UDINT;
	ltc :	UDINT;
	idate :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DST
IEC_LANGUAGE: ST
*)
yr := YEAR_OF_DATE(DT_TO_DATE(UTC));
ltc := UTC;
idate := SET_DT(yr, 3, 31, 1, 0, 0);
yr4 := DWORD_TO_UDINT(SHR(INT_TO_DWORD(5 * yr), 2)) + UDINT#1;
DST := (idate - ((yr4 + UDINT#3) MOD UDINT#7) * UDINT#86400 <= ltc) AND (idate + (UDINT#214 - (yr4) MOD UDINT#7) * UDINT#86400 > ltc);

(*
Equation used TO calculate the beginning OF European Summer TIME:
Sunday (31 - (5*y/4 + 4) mod 7) March at 01.00 UTC
(valid through 2099, courtesy of Robert H. van Gent, EC).

European Summer Time ends (clocks go back) at 01.00 UTC on

    * 29 October 2006
    * 28 October 2007
    * 26 October 2008

Equation used to calculate the end of European Summer Time:
Sunday (31 - (5*y/4 + 1) mod 7) October at 01.00 UTC
(validity AND credits as above).

*)



(* revision history
hm	4. aug 2006	rev 1.0
	original version

hm	24. okt 2007	rev 1.1
	deleted time_zone_offset input because dst is generally at 01:00 utc and not mesz
	uk starts 01:00 utc and also greece

hm	1. dec 2007	rev 1.2
	changed code to improve performance

hm	16. mar. 2008	rev 1.3
	added type conversion to avoid warnings under codesys 3.0
	code improvement for better performance

hm	7. oct. 2008	rev 1.4
	changed name of function year to year_of_date

hm	24. jan. 2011	rev 1.5
	improved performance
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION
