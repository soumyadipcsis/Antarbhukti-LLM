(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	6 jan 2008
programmer 	hugo
tested BY	hans

bar graph is a muti window comparator which displays an analog input signal on 8 digital outputs.
only one output is active a any given time depending on the value of the input signal.
the output can be of linear or logarithmic scale.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BAR_GRAPH

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	RST :	BOOL;
	TRIGGER_LOW :	REAL;
	TRIGGER_HIGH :	REAL;
	ALARM_LOW :	BOOL;
	ALARM_HIGH :	BOOL;
	LOG_SCALE :	BOOL;
END_VAR


VAR_OUTPUT
	LOW :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	Q4 :	BOOL;
	Q5 :	BOOL;
	Q6 :	BOOL;
	HIGH :	BOOL;
	ALARM :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	init :	BOOL;
	T1 :	REAL;
	T2 :	REAL;
	T3 :	REAL;
	T4 :	REAL;
	T5 :	REAL;
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: BAR_GRAPH
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	IF log_scale THEN
		temp := EXP(LN(Trigger_high / Trigger_low) * 0.166666666666666666666);
		T1 := trigger_low * temp;
		T2 := T1 * temp;
		T3 := T2 * temp;
		T4 := T3 * temp;
		T5 := T4 * temp;
	ELSE
		temp := (trigger_high - trigger_low) * 0.142857142;
		T1 := trigger_low + temp;
		T2 := T1 + temp;
		T3 := T2 + temp;
		T4 := T3 + temp;
		T5 := T4 + temp;
	END_IF;
END_IF;

(* clear outputs before checking *)
Q1 := FALSE;
Q2 := FALSE;
Q3 := FALSE;
Q4 := FALSE;
Q5 := FALSE;
Q6 := FALSE;
status := BYTE#110;

(* low, high and alarm can only be cleared with rst depending on alarm_low and alarm_high *)
IF NOT alarm_low THEN low := FALSE; END_IF;
IF NOT alarm_high THEN high := FALSE; END_IF;
IF rst THEN
	alarm := FALSE;
	low := FALSE;
	high := FALSE;
END_IF;

(* check and set outputs *)
IF X < trigger_low THEN
	Low := TRUE;
	status := BYTE#111;
	IF alarm_low THEN
		alarm := TRUE;
		status := BYTE#1;
	END_IF;
ELSIF X < T1 THEN
	Q1 := TRUE;
ELSIF x < t2 THEN
	Q2 := TRUE;
ELSIF x < t3 THEN
	Q3 := TRUE;
ELSIF x < T4 THEN
	Q4 := TRUE;
ELSIF x < T5 THEN
	q5 := TRUE;
ELSIF x < trigger_high THEN
	q6 := TRUE;
ELSE
	high := TRUE;
	status := BYTE#112;
	IF alarm_high THEN
		alarm := TRUE;
		status := BYTE#2;
	END_IF;
END_IF;

(* revision history
hm	22. feb 2007	rev 1.0
	original version

hm	2. dec 2007		rev 1.1
	chaged code for better performance

hm	6. jan 2008		rev 1.2
	further performance improvement

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
