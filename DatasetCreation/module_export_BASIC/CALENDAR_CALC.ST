(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.6	6. apr. 2011
programmer 	hugo
tested by	oscat

calendar_calc liest die weltzeit .UTC aus einer CALENDAR Struktur und berechnet die restlichen Werte der Struktur.
calendar_calc stellt sicher das die Werte fortlaufend aktualisiert werden und dabei funktionen nur dann aufgerufen werden wenn dies nötig ist.
calendar_calc will calculate sun position data when SPE = TRUE;

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CALENDAR_CALC

(*Group:Default*)


VAR_INPUT
	SPE :	BOOL;
	H :	REAL := REAL#-0.83333333333;
END_VAR


VAR_IN_OUT
	XCAL :	oscat_CALENDAR;
	HOLIDAYS :	oscat_HOLIDAY_DATA_0_29;
END_VAR


VAR
	last :	UDINT;
	last_day :	DINT;
	holy :	HOLIDAY;
	sun :	SUN_TIME;
	last_hour :	INT;
	utod :	UDINT;
	pos :	SUN_POS;
	plast :	UDINT;
	dtemp :	DINT;
	tmp :	INT;
	SETUP_LOCATION :	SETUP_LOCATION;
	LOCATION :	oscat_LOCATION;
END_VAR


(*@KEY@: WORKSHEET
NAME: CALENDAR_CALC
IEC_LANGUAGE: ST
*)
IF xcal.UTC <> last THEN
	(* run once per second *)
	(* update utc last calculated  *)
	last := XCAL.UTC;
	utod := DT_TO_TOD(xcal.UTC);

	(* calculate ltc from utc *)
	XCAL.LDT := UTC_TO_LTIME(XCAL.UTC, XCAL.DST_EN, XCAL.OFFSET);
	XCAL.LDATE := DT_TO_DATE(XCAL.LDT);
	XCAL.LTOD := DT_TO_TOD(XCAL.LDT);
	dtemp := DAY_OF_DATE(XCAL.LDATE);
	xcal.night := XCAL.LTOD < XCAL.SUN_RISE OR XCAL.LTOD > XCAL.SUN_SET;

	(* run once per hour *)
	tmp := HOUR(xcal.LTOD);
	IF  tmp <> last_hour THEN
		XCAL.DST_ON := DST(XCAL.UTC) AND xcal.DST_EN;
		last_hour := tmp;
	END_IF;

	(* run once per day *)
	IF dtemp <> last_day THEN
		SETUP_LOCATION(LOCATION:=LOCATION);
		LOCATION:=SETUP_LOCATION.LOCATION;

		last_day := dtemp;
		(* a new day has started, recalculate daily events *)
		XCAL.YEAR := YEAR_OF_DATE(XCAL.LDATE);
		XCAL.MONTH := MONTH_OF_DATE(XCAL.LDATE);
		XCAL.DAY := DAY_OF_MONTH(XCAL.LDATE);
		XCAL.WEEKDAY := DAY_OF_WEEK(XCAL.LDATE);
		HOLY(date_in := XCAL.LDATE, LANGU := xcal.LANGUAGE, HOLIDAYS := HOLIDAYS);
		HOLIDAYS := HOLY.HOLIDAYS;
		XCAL.HOLIDAY := HOLY.Y;
		XCAL.HOLY_NAME := HOLY.NAME;
		sun(latitude := XCAL.LATITUDE, longitude := xcal.LONGITUDE, utc := DT_TO_DATE(xcal.UTC), H := H);
		XCAL.SUN_RISE := DINT_TO_UDINT(UDINT_TO_DINT(sun.sun_rise) + INT_TO_DINT(XCAL.OFFSET) * DINT#60000 + SEL_DINT(XCAL.DST_ON,DINT#0,DINT#3600000));
		XCAL.SUN_SET := DINT_TO_UDINT(UDINT_TO_DINT(sun.sun_set) + INT_TO_DINT(XCAL.OFFSET) * DINT#60000 + SEL_DINT(XCAL.DST_ON,DINT#0,DINT#3600000));
		XCAL.SUN_MIDDAY := DINT_TO_UDINT(UDINT_TO_DINT(sun.midday) + INT_TO_DINT(XCAL.OFFSET) * DINT#60000 + SEL_DINT(XCAL.DST_ON,DINT#0,DINT#3600000));
		XCAL.SUN_HEIGTH := sun.sun_declination;
		XCAL.WORK_WEEK := WORK_WEEK(XCAL.LDATE);
	END_IF;

	(* calculate the suns position every 10 seconds when SPE = TRUE *)
	IF SPE AND xcal.UTC -  plast >= TIME_TO_UDINT(t#25s) THEN
		plast := last;
		pos(latitude := xcal.LATITUDE, longitude := xcal.LONGITUDE, utc := xcal.UTC);
		xcal.SUN_HOR := pos.B;
		xcal.SUN_VER := pos.HR;
	END_IF;
END_IF;

(* revision history

hm 23. oct. 2008	rev 1.0
	original version

hm	8. feb. 2009	rev 1.1
	night was calculated wrong
	added sun position data

hm	10. mar. 2009	rev 1.2
	added work_week, sun_midday, sun_heigth
	sun_position will only be calculated evey 25 seconds
	dst will only become true when dst_en = true

hm	23. jan 2010	rev 1.3
	sun_rise, sun_set and sun_midday are now calculated in local time

hm	18. jan. 2011	rev 1.4
	added input holidays to specify local holidays
	changed call for function sun_time

hm	2. feb. 2011	rev 1.5
	added input H to specify twilight

hm	6. apr. 2011	rev 1.6
	night was calculated wrong
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
