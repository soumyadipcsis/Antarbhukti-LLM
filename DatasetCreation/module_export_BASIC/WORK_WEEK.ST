(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.5	25. oct. 2008
programmer 	hugo
tested by	oscat

calculates the work week for a given date according to iso8601
(*@KEY@:END_DESCRIPTION*)
FUNCTION WORK_WEEK:INT

(*Group:Parameter*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


VAR
	d1 :	UDINT;
	w1 :	INT;
	ds :	UDINT;
	yr :	INT;
	w31 :	INT;
	w01 :	INT;
	wm :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: WORK_WEEK
IEC_LANGUAGE: ST
*)
(* berechne den 1.1 des jahres von idate. *)
yr := YEAR_OF_DATE(idate);
d1 := year_begin(yr);
(* wochentag von d1 *)
w1 := DAY_OF_WEEK(d1);
(* offset des montags der eletzten KW des vorjahres *)
(* wenn der erste tag des jahres größer als donnerstag ist dann beginnt die letzte kw am montag davor *)
(* wenn der erste tag des jahres ein donnerstag oder kleiner ist beginnt die erste kw 2 montage davor *)
IF w1 < 5 THEN
	ds := d1 - _INT_TO_UDINT(w1+6) * UDINT#86400;
ELSE
	ds := d1 + _INT_TO_UDINT(1-w1) * UDINT#86400;
END_IF;

(* kalenderwoche des eingangsdatums *)
work_week := UDINT_TO_INT((idate - ds) / UDINT#604800);

(* korrektur wenn work_week = 0 *)
IF work_week = 0 THEN
	(* work_week needs to be 53 when 1.jan of the year before is thursday or dec 31. is thursday. *)
	(* first and last weekday of a year is equal and one more day for a leap_year. *)
	IF w1 > 1 THEN w31 := w1 - 1; ELSE W31 := 7; END_IF;
	IF leap_year(yr - 1) THEN IF w31 > 1 THEN w01 := W31 - 1; ELSE w1 := 7; END_IF; END_IF;
	(* if first or last day of a year is a thursday, the year has 53 weeks *)
	WORK_WEEK := 52 + BOOL_TO_INT(w31 = 4 OR w01 = 4);
ELSE
	(* end of year calculation *)
	(* calculated the first and last weekday *)
	IF leap_year(yr) THEN
		IF w1 < 7 THEN w31 := w1 + 1; ELSE w31 := 1; END_IF;
	ELSE
		w31 := w1;
	END_IF;
	(* if first or last day is thursday then the year has 53 weeks otherwise only 52 *)
	wm := 52 + BOOL_TO_INT(w31 = 4 OR w1 = 4);
	IF work_week > wm THEN work_week := 1; END_IF;
END_IF;




(* old code before rev 1.2
w1 := weekday(set_Date(year(idate), 1,1));
IF w1 < 5 THEN
	work_week := (day_of_year(idate) + w1 + 5)/7;
ELSE
	work_week := (day_of_year(idate) + w1 - 2)/7;
END_IF
*)


(* revision history

hm 	17.1.2007		rev 1.1
	deleted unused variable yday

hm	19. dec 2007	rev 1.2
	changed code for better performance
	changed code to comply with ISO8601

hm	16. mar 2008	rev 1.3
	added type conversions to avoid warnings under codesys 3.0

hm	7. oct. 2008	rev 1.4
	changed function year to year_of_date
	changed function weekday to day_of_week

hm	25. oct. 2008	rev 1.5
	optimized code for performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
