(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	7. oct. 2008
programmer 	oscat
tested by	tobias

TIMER_EXT is a twilight timer.
the timer can be programmed to switch lights or other equippment or during twilight times.
in addition to the automatik mode the timer can be stopped and started by a switch at any given time.
An enable input ENA can be used for external control.
two inputs ON and OFF can be used to statically control the output.
the timer can be programmed to work on saturdays, sundays and holidays if required.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TIMER_EXT

(*Group:Default*)


VAR_INPUT
	ENA :	BOOL;
	ON :	BOOL;
	OFF :	BOOL;
	MAN :	BOOL;
	SWITCH :	BOOL;
	DT_IN :	UDINT;
	SUN_SET :	UDINT;
	SUN_RISE :	UDINT;
	HOLIDAY :	BOOL;
	T_DEBOUNCE :	TIME := T#100ms;
	T_RISE_START :	TIME;
	T_RISE_STOP :	TIME;
	T_SET_START :	TIME;
	T_SET_STOP :	TIME;
	T_DAY_START :	UDINT;
	T_DAY_STOP :	UDINT;
	ENABLE_SATURDAY :	BOOL;
	ENABLE_SUNDAY :	BOOL;
	ENABLE_HOLIDAY :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	mx :	MANUAL_2;
	deb :	DEBOUNCE;
	tdx :	UDINT;
	wdx :	INT;
	tc :	TIME;
	tx :	UDINT;
	tl :	UDINT;
	qx :	BOOL;
	T_PLC_MS :	T_PLC_MS;
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TIMER_EXT
IEC_LANGUAGE: ST
*)
(* lösche die millisekunden bei sunrise und sunset *)
SUN_RISE := SUN_RISE / UDINT#1000 * UDINT#1000;
SUN_SET := SUN_SET / UDINT#1000 * UDINT#1000;

(* measure cycle time tc and make sure this circuitry is not called more then once in 200ms*)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;
IF NOT init THEN
	init := TRUE;
	tl := tx;
END_IF;
tc := UDINT_TO_TIME(tx - tl);
IF tc < t#200ms THEN RETURN; END_IF;
tl := tx;

(* debounce *)
deb(in := SWITCH, TD := T_DEBOUNCE, PM := TRUE);

(* read time of day and strip off all milliseconds *)
tdx := DT_TO_TOD(dt_in);
wdx := DAY_OF_WEEK(DT_TO_DATE(dt_in));

(* automatic output control *)
IF deb.Q THEN
	qx := NOT qx;
	status := BYTE#110;
ELSIF holiday AND NOT enable_holiday THEN
	qx := FALSE;
ELSIF wdx = 6 AND NOT enable_saturday THEN
	qx := FALSE;
ELSIF wdx = 7 AND NOT enable_sunday THEN
	qx := FALSE;
ELSIF T_day_start > UDINT#00 (* TOD#00:00 *) AND tdx - T_DAY_START <= TIME_TO_UDINT(tc) THEN
	(* turn on at specified daytime *)
	qx := TRUE;
	status := BYTE#111;
ELSIF T_DAY_STOP > UDINT#00 (* TOD#00:00 *) AND tdx - T_DAY_STOP <= TIME_TO_UDINT(tc) THEN
	(* turn off at specific daytime *)
	qx := FALSE;
	status := BYTE#112;
ELSIF T_RISE_START > T#0s AND tdx - SUN_RISE + TIME_TO_UDINT(T_RISE_START) <= TIME_TO_UDINT(tc) THEN
	(* turn on before sunrise *)
	qx := TRUE;
	status := BYTE#113;
ELSIF T_RISE_STOP > T#0s AND tdx - SUN_RISE - TIME_TO_UDINT(T_RISE_STOP) <= TIME_TO_UDINT(tc) THEN
	(* turn off after sunrise *)
	qx := FALSE;
	status := BYTE#114;
ELSIF T_SET_start > T#0s AND tdx - SUN_SET + TIME_TO_UDINT(T_SET_START) <= TIME_TO_UDINT(tc) THEN
	(* turn on before sunset *)
	qx := TRUE;
	status := BYTE#115;
ELSIF T_SET_STOP > T#0s AND tdx - SUN_SET - TIME_TO_UDINT(T_SET_STOP) <= TIME_TO_UDINT(tc) THEN
	(* turn off after sunset *)
	qx := FALSE;
	status := BYTE#116;
END_IF;

(* manual and output control *)
mx(in := qx, ena := ENA, on := ON, off := OFF, man := MAN);
Q := mx.Q;

(* set the status output *)
IF mx.STATUS > BYTE#100 THEN status := mx.STATUS; END_IF;



(*
hm 7. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
