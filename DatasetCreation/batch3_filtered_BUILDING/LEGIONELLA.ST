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
programmer 	oscat
tested by	oscat

Legionella is a complete sequencer for up to 8 hot water lines that need to be sterilzed periodically.
legionella needs a DT input with the appropriate time, usually gererated by the rtc of the system. for system independence this time is connected externally.
T_start is the time when sterilazation should be started and day is the day_of_week when it should be performed (1=Monday and 7=sunday).
so sterilazation is autioimatically performed once a week at a specified time.
temp_set and temp_hys and temp_offset specify the boiler temperatur nedded for sterilization. as a defaut Temp_set is set to 70 deg C and Temp_hys is set to 5 deg C and temp_offset is 10 deg C.
a temp boiler input reads the boiler temperature of the hot water tank.
after a start pulse is gererated by the weekly timer or a manual test input the sequence is started:
1. the boiler is heated to temp_set + temp_offset + temp_hys = 85 deg C unless chaged at setup.
	the heat output is turned on and tells the heater to turn heating on. if the temp is not reached for a time of t_max_heat (10 min) the error output is set and the sequence is stopped.
2. after the specified temperature is reached, the output valve0 and pump is turned on and starts sterilization of line0 until temp_return has reached temp_set and continues to sterilize for a time of tp_0 (5 min default).
	if tmep_set is not reached at the temp_return_input then the error output is set and the sequence will be stopped.
	if there is no temp sensor for temp_return (the temperature at the return point for the circulation pump pls set this imput to a value greater then temp_set (by default use 100 deg C).
	in this case sterilization is performed for the default times without monitoring the return temp.
3. this sequence is repeated for up to valves.

connection scheme:

temp_boiler:	input oif the boiler temperature sensor.
temp_hys:		config value for the heater hysteresis, preset to 5 deg C.
temp_offset:	config value for the heater temp_offset against temp_set, preset to 10 deg C.
temp_set:		config value for the specified sterilization temperature, preset to 70 deg C.
temp_return:	input of the circulation return line temperature sensor, if not availabe set this value to 100 deg C.
manual:		manual input to start the sterilization by hand for diagnostic purposes, rising edge active, leave low for automatic operation.
DT_in:			date,time input supplied by a external real time clock.
T_start:		time of day when the sterilization should be started.
day:			config value for day of week when the process should be started, preset to sunday.
t_max_hest:	tmax time to be needed for the heater to heat the hot water tank to the specified value, preset to 10 min.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LEGIONELLA

(*Group:Default*)


VAR_INPUT
	MANUAL :	BOOL;
	TEMP_BOILER :	REAL;
	TEMP_RETURN :	REAL := 100.0;
	DT_IN :	UDINT;
	RST :	BOOL;
	T_START :	UDINT := UDINT#10800000;(*tod#03:00:00*)
	DAY :	INT := 7;
	TEMP_SET :	REAL := 70.0;
	TEMP_OFFSET :	REAL := 10.0;
	TEMP_HYS :	REAL := 5.0;
	T_MAX_HEAT :	TIME := t#10m;
	T_MAX_RET :	TIME := t#10m;
	TP_0 :	TIME := t#5m;
	TP_1 :	TIME := t#5m;
	TP_2 :	TIME := t#5m;
	TP_3 :	TIME := t#5m;
	TP_4 :	TIME := t#5m;
	TP_5 :	TIME := t#5m;
	TP_6 :	TIME := t#5m;
	TP_7 :	TIME := t#5m;
END_VAR


VAR_OUTPUT
	HEAT :	BOOL;
	PUMP :	BOOL;
	VALVE0 :	BOOL;
	VALVE1 :	BOOL;
	VALVE2 :	BOOL;
	VALVE3 :	BOOL;
	VALVE4 :	BOOL;
	VALVE5 :	BOOL;
	VALVE6 :	BOOL;
	VALVE7 :	BOOL;
	RUN :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	X1 :	timer_1;
	x2 :	sequence_8;
	x3 :	hyst_1;
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: LEGIONELLA
IEC_LANGUAGE: ST
*)
(* startup initialization *)
IF NOT init THEN
	init := TRUE;
	X1.day := SHR(BYTE#128,day);
	X1.start := T_start;
	X3.low := Temp_offset + temp_set;
	X3.high := Temp_hys + X3.low;
	X2.wait0 := T_max_heat;
	X2.delay0 := TP_0;
	X2.delay1 := TP_1;
	X2.delay2 := TP_2;
	X2.delay3 := TP_3;
	X2.delay4 := TP_4;
	X2.delay5 := TP_5;
	X2.delay6 := TP_6;
	X2.delay7 := TP_7;
	X2.wait1 := T_max_ret;
	X2.wait2 := T_max_ret;
	X2.wait3 := T_max_ret;
	X2.wait4 := T_max_ret;
	X2.wait5 := T_max_ret;
	X2.wait6 := T_max_ret;
	X2.wait7 := T_max_ret;
	X2();
END_IF;

(* oerational code *)
X1(DTi := DT_in);
IF X1.Q OR MANUAL OR x2.run THEN
	X3(in := temp_boiler);
	X2.in0 := X3.Q OR x3.win;
	X2.in1 := temp_return >= temp_set;
	X2.in2 := x2.in1;
	X2.in3 := x2.in1;
	X2.in4 := x2.in1;
	X2.in5 := x2.in1;
	X2.in6 := x2.in1;
	X2.in7 := x2.in1;
	X2.rst := rst;
	X2(start := X1.Q OR MANUAL);
	run := x2.run;
	pump := x2.QX;
	Heat := NOT X3.Q AND x2.run;
	valve0 := X2.Q0;
	valve1 := X2.Q1;
	valve2 := X2.Q2;
	valve3 := X2.Q3;
	valve4 := X2.Q4;
	valve5 := X2.Q5;
	valve6 := X2.Q6;
	valve7 := X2.Q7;
	pump := X2.QX;
	status := X2.status;
ELSE;
	X2(start := FALSE);
	status := x2.status;
END_IF;

(* revision history

hm 17.jan 2007	rev 1.1
	rewritten to st for higher performance
	changes eeror output to esr compatible status output

hm	23. 10.2008	rev 1.2
	update code to use new version of timer_1

hm	13. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
