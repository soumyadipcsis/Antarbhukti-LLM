(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	27. feb. 2009
programmer 	hugo
tested BY	oscat

m_d measures the time between a rising edge on start to a rising edge on stop and returs the last measured value on the output PT.
a second output ET is starting from 0 at the rising edge of start and is counting up until the rising edge of stop occurs.
the asynchronous input rst can reset the outputs at any time.
tmax defines a timeout wich is the maximum measurable time between start and stop, if this time is exceeded the outputs will stay at 0.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK M_D

(*Group:Default*)


VAR_INPUT
	START :	BOOL;
	STOP :	BOOL;
	TMAX :	TIME := t#10d;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	PT :	TIME;
	ET :	TIME;
	RUN :	BOOL;
END_VAR


VAR
	edge :	BOOL;
	T0 :	TIME;
	tx :	TIME;
	startup :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: M_D
IEC_LANGUAGE: ST
*)
(* check for rst input *)
IF rst OR et >= tmax THEN
	pt := t#0ms;
	et := t#0ms;
	startup := FALSE;
	run := FALSE;
END_IF;

(* avoid timers to start when input is true at startup *)
IF NOT startup THEN
	edge := start;
	startup := TRUE;
END_IF;

(* read system timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* detect rising edge on start *)
IF start AND NOT edge AND NOT stop THEN
	t0 := tx;
	run := TRUE;
	pt := t#0s;
ELSIF stop AND run THEN
	pt := et;
	run := FALSE;
END_IF;
edge := start;
IF run THEN et := tx - t0; END_IF;

(* revision history
hm		2.5.2007	rev 1.0
	original version

hm		16.9.2007	rev 1.1
	changes time() to T_plc_ms() for compatibility reasons

hm	27. feb 2009	rev 1.2
	deleted unnecessary init with 0
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
