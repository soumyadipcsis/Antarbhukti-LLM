(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	8. mar. 2009
programmer 	hugo
tested by	oscat

DT_SIMU simulates a real time clock and can be adjusted to different speeds
it can also be used in simulation to simulate a real time clock.
the peed of the clock can be increased or decreased to debug timers.
with the input start a start date-time can be specified.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DT_SIMU

(*Group:Default*)


VAR_INPUT
	START :	UDINT;
	SPEED :	REAL := 1.0;
END_VAR


VAR_OUTPUT
	DTS :	UDINT;
END_VAR


VAR
	tc :	UDINT;
	init :	BOOL;
	last :	UDINT;
	tx :	UDINT;
	td :	UDINT;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: DT_SIMU
IEC_LANGUAGE: ST
*)
(* read system timer *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;
tc := _REAL_TO_UDINT(UDINT_TO_REAL(tx - last) * speed);

IF NOT init THEN
	init := TRUE;
	DTS := Start;
	tc := UDINT#0;
	last := tx;
ELSIF SPEED = 0.0 THEN
	DTS := DTS + UDINT#1;
ELSIF tc >= UDINT#1000 THEN
	td := (tc / UDINT#1000) * UDINT#1000;
	DTS := DTS + td;
	last := last + _REAL_TO_UDINT(UDINT_TO_REAL(td) / speed);
END_IF;

(* revision history
hm	11. sep. 2008	rev 1.0
	original version

hm	16. nov	2008	rev 1.1
	added type conversions for compatibility reasons

hm	8.	mar. 2009	rev 1.2
	added increment by cycle mode
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
