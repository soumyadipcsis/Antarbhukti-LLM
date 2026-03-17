(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	22. mar. 2008
programmer 	hugo
tested by	tobias

PERIOD checks if a given date is between two dates (d1 and d2) d1 is the starting date and d2 the last date for the period.
the years of the dates are ignored, so the function period cheks for a time period within a year independet of the year.
(*@KEY@:END_DESCRIPTION*)
FUNCTION PERIOD:BOOL

(*Group:Default*)


VAR
	day1 :	INT;
	day2 :	INT;
	dayx :	INT;
END_VAR


VAR_INPUT
	D1 :	UDINT;
	Dx :	UDINT;
	D2 :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: PERIOD
IEC_LANGUAGE: ST
*)
day1 := day_of_year(d1);
day2 := day_of_year(d2);
dayx := day_of_year(dx);
IF NOT leap_of_Date(dx) AND dayx > 58 THEN dayx := dayx + 1; END_IF;
IF NOT leap_of_Date(d1) AND day1 > 58 THEN day1 := day1 + 1; END_IF;
IF NOT leap_of_Date(d2) AND day2 > 58 THEN day2 := day2 + 1; END_IF;

IF day2 < day1 THEN
	(* the period spans over the new year *)
	period := dayx <= day2 OR dayx >= day1;
ELSE
	period := dayx >= day1 AND dayx <= day2;
END_IF;

(* code before rev 1.2
yx := year(dx);
p1 := date_add(d1,0,0,0,yx - year(d1));
p2 := date_add(d2,0,0,0,yx - year(d2));

IF p2 >= p1 THEN
	period := dx <= p2  AND dx >= p1;
ELSE
	period := dx <= p2 OR dx >= p1;
END_IF;
*)


(* revision history

hm		19. sep 2007	rev 1.0
	original version

hm		20. sep 2007	rev 1.1
	corrected a problem with leap year

hm		4. jan 2008		rev 1.2
	changed code for better performance

hm		22. mar. 2008	rev 1.3
	function would deliver wrong results when d1, d2 or dx are a leap_year

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
