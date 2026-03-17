(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	16 sep 2007
programmer 	hugo
tested BY	hans

this function block measures the cycle time and displays the last, min and max cycle time of the current task.
the resolution is 1ms.
the cycles output is a dword counter which counts the cycles.
a rst pulse on the input will reset all data.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CYCLE_TIME

(*Group:Default*)


VAR_INPUT
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	CT_MIN :	TIME := t#0s;
	CT_MAX :	TIME := t#0s;
	CT_LAST :	TIME;
	SYSTIME :	TIME;
	SYSDAYS :	INT;
	CYCLES :	DWORD;
END_VAR


VAR
	last_cycle :	TIME;
	tx :	TIME;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: CYCLE_TIME
IEC_LANGUAGE: ST
*)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) - last_cycle;

IF rst THEN
	ct_min := t#10h;
	ct_max := t#0ms;
	cycles := DWORD#0;
ELSIF last_cycle > t#0s THEN
	IF tx < ct_min THEN ct_min := tx;
	ELSIF tx > ct_max THEN ct_max := tx;
	END_IF;
	ct_last := tx;
ELSIF ct_min = t#0s THEN
	ct_min := t#0s - t#1ms;
END_IF;
IF init THEN
	systime := systime + tx;
		IF systime >= t#1d THEN
			systime := systime - t#1d;
			sysdays := sysdays + 1;
		END_IF;
END_IF;
init := TRUE;
last_cycle := last_cycle + tx;
cycles := UDINT_TO_DWORD(DWORD_TO_UDINT(cycles) + UDINT#1);

(*	revision history
hm 12.12.2006		rev 1.1
	added cycles output, a dword cycle counter.
hm 10.3.2007			rev 1.2
	changed initialization of ct_min to t#10h for compatibility with siemens s7

hm	16.9.2007		rev 1.2
	changed Time() in T_PLC_MS() for compatibility resons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
