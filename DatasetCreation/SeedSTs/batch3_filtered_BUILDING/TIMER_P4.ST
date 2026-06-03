(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.4	26. jan. 2011
programmer 	hugo
tested by	oscat

TIMER_P4 is a programmable universal timer.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TIMER_P4

(*Group:Default*)


VAR_INPUT
	DTIME :	UDINT;
	TREF_0 :	UDINT;
	TREF_1 :	UDINT;
	HOLY :	BOOL;
	L0 :	BOOL;
	L1 :	BOOL;
	L2 :	BOOL;
	L3 :	BOOL;
	OFS :	BYTE;
	ENQ :	BOOL;
	MAN :	BOOL;
	MI :	BYTE;
	RST :	BOOL;
END_VAR


VAR_IN_OUT
	PROG :	oscat_TIMER_EVENT;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	day_start :	UDINT;
	start :	UDINT;
	event :	oscat_TIMER_EVENT_DATA;
	pos :	INT;
	last_execute :	UDINT;
	current_day :	DINT;
	mask :	BYTE;
	ma :	oscat_arb_0_3;
	mo :	oscat_arb_0_3;
	qn :	oscat_TP4_qn;
	qs :	oscat_TP4_qn;
	channel :	INT;
	tx :	UDINT;
	array_max :	INT := 63;
	channel_max :	INT := 3;
END_VAR


(*@KEY@: WORKSHEET
NAME: TIMER_P4
IEC_LANGUAGE: ST
*)
(* for performance reasons we only execute the code at the beginning of a new second *)

IF RST THEN
	(* reset all events to last active on 1.1.1970 *)
	last_execute := UDINT#00; (* DT#1970-1-1-00:00 *)
	FOR pos := 0 TO ARRAY_MAX DO
		IF (PROG[pos].CHANNEL >= OFS) AND (_BYTE_TO_INT(PROG[pos].CHANNEL) < (_BYTE_TO_INT(OFS) + 4)) THEN PROG[pos].LAST := last_execute; END_IF;
	END_FOR;

	(* reset all set markers and logic masks *)
	FOR pos := 0 TO channel_max DO
		qs[pos] := FALSE;
	END_FOR;

(* normal operation *)
ELSIF dtime <> last_execute THEN
	(* save the actual second for next execution test *)
	last_execute := DTIME;

	(* calculate dt for the start of the day to be used in comparisons *)
	day_start := DATE_TO_DT(DT_TO_DATE(DTIME));

	(* set all qn to FALSE *)
	FOR pos := 0 TO channel_max DO qn[pos] := FALSE; END_FOR;

	(* search the array PROG for timer events *)
	FOR pos := 0 TO ARRAY_MAX DO
		event := prog[pos];
		channel := _BYTE_TO_INT(event.CHANNEL) - _BYTE_TO_INT(OFS);
		IF (event.TYP > BYTE#0) AND (channel >= 0) AND (channel <= channel_max) THEN
			ma[channel] := event.LAND;
			mo[channel] := event.LOR;
			CASE _BYTE_TO_INT(event.TYP) OF
				1:	(* daily event *)
					start := day_start + event.start;
					qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);

				2: 	(* event by selected weekdays *)
					IF (SHR(BYTE#128, DAY_OF_WEEK(DT_TO_DATE(Dtime))) AND event.DAY) > BYTE#0 THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				3:	(* event every N days *)
					IF current_day MOD _BYTE_TO_DINT(event.DAY) = DINT#0 THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				10:	(* weekly event exactly once a week the weekday is specified in day, 1= mo *)
					IF DAY_OF_WEEK(DT_TO_DATE(DTIME)) = BYTE_TO_INT(event.DAY) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				20:	(* monthly event *)
					IF DAY_OF_MONTH(DT_TO_DATE(DTIME)) = BYTE_TO_INT(event.DAY) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				21:	(* event on last day of month *)
					IF DT_TO_DATE(DTIME) = MONTH_END(DT_TO_DATE(dtime)) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				30:	(* yearly event on a specific day specified in day *)
					IF DAY_OF_YEAR(DT_TO_DATE(DTIME)) = BYTE_TO_INT(event.DAY) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				31:	(* event on last day of year *)
					IF DT_TO_DATE(DTIME) = YEAR_END(YEAR_OF_DATE(DT_TO_DATE(dtime))) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				40:	(* event on leap days *)
					IF LEAP_DAY(DT_TO_DATE(dtime)) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				41: (* event on holidays *)
					IF HOLY THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				42: (* event on holidays and weekends *)
					IF (Holy OR (DAY_OF_WEEK(DT_TO_DATE(dtime)) = 6) OR (DAY_OF_WEEK(DT_TO_DATE(dtime)) = 7)) THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				43:	(* event on workdays Mo-FR and no holiday *)
					IF DAY_OF_WEEK(DT_TO_DATE(dtime)) < 6 THEN
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);
					END_IF;

				50: (* event after reference time *)
					CASE _BYTE_TO_INT(prog[pos].DAY) OF
						0:	tx := tref_0;
						1:	tx := tref_1;
					ELSE
						tx := UDINT#0 (* TOD#00:00 *);
					END_CASE;
					start := day_start + tx + event.start;
					qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);

				51:	(* event before reference time *)
					CASE _BYTE_TO_INT(prog[pos].DAY) OF
						0:	tx := tref_0;
						1:	tx := tref_1;
					ELSE
						tx := UDINT#0 (* TOD#00:00 *);
					END_CASE;
					start := day_start + tx - event.start;
					qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT(event.DURATION);

				52 : (* set output at specific time + offset  *)
					CASE _BYTE_TO_INT(prog[pos].DAY) OF
						0:	tx := tref_0;
						1:	tx := tref_1;
					ELSE
						tx := UDINT#0 (* TOD#00:00 *);
					END_CASE;
					start := day_start + tx + event.start;
					IF dtime >= start AND day_start > event.LAST THEN
						qs[channel] := TRUE;
						prog[pos].LAST := day_start;
					END_IF;

				53 : (* reset output at specific time + offset *)
					CASE _BYTE_TO_INT(prog[pos].DAY) OF
						0:	tx := tref_0;
						1:	tx := tref_1;
					ELSE
						tx := UDINT#0 (* TOD#00:00 *);
					END_CASE;
					start := day_start + tx + event.start;
					IF dtime >= start AND day_start > event.LAST THEN
						qs[channel] := FALSE;
						prog[pos].LAST := day_start;
					END_IF;

				54 : (* set output at specific time - offset  *)
					CASE _BYTE_TO_INT(prog[pos].DAY) OF
						0:	tx := tref_0;
						1:	tx := tref_1;
					ELSE
						tx := UDINT#0 (* TOD#00:00 *);
					END_CASE;
					start := day_start + tx - event.start;
					IF dtime >= start AND day_start > event.LAST THEN
						qs[channel] := TRUE;
						prog[pos].LAST := day_start;
					END_IF;

				55 : (* reset output at specific time - offset *)
					CASE _BYTE_TO_INT(prog[pos].DAY) OF
						0:	tx := tref_0;
						1:	tx := tref_1;
					ELSE
						tx := UDINT#0 (* TOD#00:00 *);
					END_CASE;
					start := day_start + tx - event.start;
					IF dtime >= start AND day_start > event.LAST THEN
						qs[channel] := FALSE;
						prog[pos].LAST := day_start;
					END_IF;
			END_CASE;
		END_IF;
	END_FOR;
END_IF;

(* prepare the logical input mask *)
mask := BYTE#255;
mask:=BIT_LOAD_B(mask,L0,0);
mask:=BIT_LOAD_B(mask,L1,1);
mask:=BIT_LOAD_B(mask,L2,2);
mask:=BIT_LOAD_B(mask,L3,3);

(* set the outputs *)
Q0 := ENQ AND ((qn[0] OR qs[0]) AND ((ma[0] AND mask) = ma[0]) OR ((mo[0] AND mask) > BYTE#0) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),0)));
Q1 := ENQ AND ((qn[1] OR qs[1]) AND ((ma[1] AND mask) = ma[1]) OR ((mo[1] AND mask) > BYTE#1) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),1)));
Q2 := ENQ AND ((qn[2] OR qs[2]) AND ((ma[2] AND mask) = ma[2]) OR ((mo[2] AND mask) > BYTE#2) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),2)));
Q3 := ENQ AND ((qn[3] OR qs[3]) AND ((ma[3] AND mask) = ma[3]) OR ((mo[3] AND mask) > BYTE#3) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),3)));

(* set status *)
IF NOT enq THEN
	status := BYTE#100;
ELSIF man THEN
	status := BYTE#101;
ELSE
	status := BYTE#102;
END_IF;



(* revision history
hm	17. jun 2008	rev 1.0
	original version

hm	9. oct. 2008	rev 1.1
	changed function year to year_of_date
	changed function weekday to day_of_week
	changed structure of program to be more efficient
	changed input DIS to ENQ

hm	18. oct. 2008	rev 1.2
	changed type of input OFS from int to byte
	added typecasts to avoid warnings

hm	28. feb. 2009	rev 1.3
	array was not correctly initialized

hm	26. jan 2011	rev 1.4
	changed code to allow events over midnight
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
