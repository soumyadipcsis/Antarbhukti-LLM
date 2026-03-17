(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.3	13. mar. 2009
programmer 	hugo
tested by	oscat

temp_ext measures and processes ext temperature and decides if heating or cooling is needed.

 the measurement of t_ext has 3 inputs which can be configured in different ways:
	t_ext_config = 0 means the ext temp is the avg of the 3 external temperatures, this mode is the default mode.
	t_ext_config = 1 means t_ext1 is used.
	t_ext_config = 2 means t_ext1 is used.
	t_ext_config = 3 means t_ext1 is used.
	t_ext_config = 4 means t_ext_default is used.
	t_ext_config = 5 means the lowest of the 3 external temperatures is used.
	t_ext_config = 6 means the higest externnal temperature is used.
	t_ext_config = 7 means the midlle external temperature is used, if there are only two working, the lowest is used.
	in any config mode, an external temperature higher then t_ext_max or lower then t_ext_min is ignored to prevent from temperatures caused by broken sensors or wires.
	if no external temperature is available, a default value (t_ext_default) is used.
	if you have only one external sensor, connect the 3 inputs to the same sensor, or select the right input with t_ext_config.

heating or cooling is enabled during heating / cooling period when the day or night start temperature is reached for at least the specified delay time and will be disabled after the stop temperature is reached. 
t_ext output can be used by other modules to determine the correct system temperature for heating or cooling.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TEMP_EXT

(*Group:Default*)


VAR_INPUT
	T_EXT1 :	REAL;
	T_EXT2 :	REAL;
	T_EXT3 :	REAL;
	T_EXT_CONFIG :	BYTE := 0;
	DT_IN :	UDINT;
	T_EXT_MIN :	REAL := REAL#-40.0;
	T_EXT_MAX :	REAL := REAL#60.0;
	T_EXT_DEFAULT :	REAL := REAL#-10.0;
	HEAT_PERIOD_START :	UDINT := UDINT#20995200;(*Anfangswert: D#1970-9-1*)
	HEAT_PERIOD_STOP :	UDINT := UDINT#10281600;(*Anfangswert: D#1970-4-30*)
	COOL_PERIOD_START :	UDINT := UDINT#07776000;(*Anfangswert: D#1970-4-1*)
	COOL_PERIOD_STOP :	UDINT := UDINT#23500800;(*Anfangswert: D#1970-9-30*)
	HEAT_START_TEMP_DAY :	REAL := REAL#15.0;
	HEAT_START_TEMP_NIGHT :	REAL := REAL#10.0;
	HEAT_STOP_TEMP :	REAL := REAL#18.0;
	COOL_START_TEMP_DAY :	REAL := REAL#26.0;
	COOL_START_TEMP_NIGHT :	REAL := REAL#26.0;
	COOL_STOP_TEMP :	REAL := REAL#24.0;
	START_DAY :	UDINT := UDINT#32400000;(*Anfangswert:TOD#09:00*)
	START_NIGHT :	UDINT := UDINT#75600000;(*Anfangswert:TOD#21:00*)
	CYCLE_TIME :	TIME := t#10m;
END_VAR


VAR_OUTPUT
	T_EXT :	REAL;
	HEAT :	BOOL;
	COOL :	BOOL;
END_VAR


VAR
	tx :	TIME;
	last_run :	TIME;
	init :	BOOL;
	cool_start :	UDINT;
	cool_stop :	UDINT;
	heat_start :	UDINT;
	heat_stop :	UDINT;
	xdate :	UDINT;
	day :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TEMP_EXT
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	heat_start := SET_DATE(1972,MONTH_OF_DATE(heat_period_start),DAY_OF_MONTH(heat_period_start));
	heat_stop := SET_DATE(1972,MONTH_OF_DATE(heat_period_stop),DAY_OF_MONTH(heat_period_stop));
	cool_start := SET_DATE(1972,MONTH_OF_DATE(cool_period_start),DAY_OF_MONTH(cool_period_start));
	cool_stop := SET_DATE(1972,MONTH_OF_DATE(cool_period_stop),DAY_OF_MONTH(cool_period_stop));
END_IF;

(* read system time *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* for efficiency exit isf this program has been executed less then 1min ago *)
IF tx - last_run < cycle_time THEN RETURN; END_IF;

(* calculate frequently used variables *)
xdate := SET_DATE(1972,MONTH_OF_DATE(DT_TO_DATE(dt_in)),DAY_OF_MONTH(DT_TO_DATE(dt_in)));
day := DT_TO_TOD(dt_in) >= start_day AND  DT_TO_TOD(dt_in) < start_night;

(* read the correct external temperature depending on the t_ext_config setting *)
t_ext := MULTI_IN(t_ext1, t_ext2, t_ext3, t_ext_default, t_ext_min, t_ext_max, t_ext_config);

(* dtermine heating *)
IF (heat_start <= heat_stop AND xdate >= heat_start AND xdate <= heat_stop) OR (heat_start > heat_stop AND (xdate >= heat_start OR xdate <= heat_stop)) THEN
	(* heating period id true check for temperature *)
	IF day AND t_ext <= heat_start_temp_day THEN
		heat := TRUE;
	ELSIF NOT day AND t_ext <= heat_start_temp_night THEN
		heat := TRUE;
	ELSIF t_ext >= heat_stop_temp THEN
		heat := FALSE;
	END_IF;
ELSE
	heat := FALSE;
END_IF;

(* dtermine cooling *)
IF (cool_start <= cool_stop AND xdate >= cool_start AND xdate <= cool_stop) OR (cool_start > cool_stop AND (xdate >= cool_start OR xdate <= cool_stop)) THEN
	(* cooling period is true check for temperature *)
	IF day AND t_ext >= cool_start_temp_day THEN
		cool := TRUE;
	ELSIF NOT day AND t_ext >= cool_start_temp_night THEN
		cool := TRUE;
	ELSIF t_ext <= cool_stop_temp THEN
		cool := FALSE;
	END_IF;
ELSE
	cool := FALSE;
END_IF;

last_run := tx;

(* revision history
hm	6 dec 2006	rev 1.0
	original version

hm	15.9.2007		rev 1.1
	replaced Time() with T_PLC_MS for compatibility and performance reasons

hm	7. oct. 2008	rev 1.2
	changed name of function month to month_of_date

hm	13. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
