(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 2.1	10. mar. 2009
programmer 	hugo
tested by	tobias

returns the day OF month for any DATE
(*@KEY@:END_DESCRIPTION*)
FUNCTION DAY_OF_MONTH:INT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DAY_OF_MONTH
IEC_LANGUAGE: ST
*)
day_of_month := day_of_year(idate);

IF leap_of_Date(idate) THEN
	CASE day_of_month OF
		32..60	:	day_of_month := day_of_month - 31;
		61..91	:	day_of_month := day_of_month - 60;
		92..121 :	day_of_month := day_of_month - 91;
		122..152:	day_of_month := day_of_month - 121;
		153..182:	day_of_month := day_of_month - 152;
		183..213:	day_of_month := day_of_month - 182;
		214..244:	day_of_month := day_of_month - 213;
		245..274:	day_of_month := day_of_month - 244;
		275..305:	day_of_month := day_of_month - 274;
		306..335:	day_of_month := day_of_month - 305;
		336..366:	day_of_month := day_of_month - 335;
	END_CASE;
ELSE
	CASE day_of_month OF
		32..59	:	day_of_month := day_of_month - 31;
		60..90	:	day_of_month := day_of_month - 59;
		91..120 :	day_of_month := day_of_month - 90;
		121..151:	day_of_month := day_of_month - 120;
		152..181:	day_of_month := day_of_month - 151;
		182..212:	day_of_month := day_of_month - 181;
		213..243:	day_of_month := day_of_month - 212;
		244..273:	day_of_month := day_of_month - 243;
		274..304:	day_of_month := day_of_month - 273;
		305..334:	day_of_month := day_of_month - 304;
		335..365:	day_of_month := day_of_month - 334;
	END_CASE;
END_IF;

(*
Revision history

hm 22.1.2007		rev 1.1
	deleted unused variable day_in_year and day_in_year_begin

hm	1. okt 2007	rev 1.2
	changed code to use day_of_year and leap_of_date
	added compatibility to STEP7

hm	8. oct 2007	rev 1.3
	deleted unused variable yr

hm	8. jan 2008	rev 1.4
	improved performance

hm	25. oct. 2008	rev 2.0
	new code using setup constants

hm	10. mar. 2009	rev 2.1
	removed nested comments
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
