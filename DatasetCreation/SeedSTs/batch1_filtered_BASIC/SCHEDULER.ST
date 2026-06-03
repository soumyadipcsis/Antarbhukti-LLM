(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	28. sep 2008
programmer 	hugo
tested by	tobias

SCHEDULER is used to call programs or function blocks at specific intervals.
T0..T3 defines the interval times.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SCHEDULER

(*Group:Default*)


VAR_INPUT
	E0 :	BOOL;
	E1 :	BOOL;
	E2 :	BOOL;
	E3 :	BOOL;
	T0 :	TIME;
	T1 :	TIME;
	T2 :	TIME;
	T3 :	TIME;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
END_VAR


VAR
	T_PLC_MS :	T_PLC_MS;
	init :	BOOL;
	s0 :	TIME;
	s1 :	TIME;
	s2 :	TIME;
	s3 :	TIME;
	tx :	TIME;
	c :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SCHEDULER
IEC_LANGUAGE: ST
*)
(* read sps timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF NOT init THEN
	init := TRUE;
	s0 := tx - T0;
	s1 := tx - T1;
	s2 := tx - T2;
	s3 := tx - T3;
END_IF;

Q0 := FALSE;
Q1 := FALSE;
Q2 := FALSE;
Q3 := FALSE;

CASE c OF
	0: 	IF tx - s0 >= T0 THEN
			Q0 := E0;
			s0 := tx;
		END_IF;
		c := 1;
	1: 	IF tx - s1 >= T1 THEN
			Q1 := E1;
			s1 := tx;
		END_IF;
		c := 2;
	2: 	IF tx - s2 >= T2 THEN
			Q2 := E2;
			s2 := tx;
		END_IF;
		c := 3;
	3: 	IF tx - s3 >= T3 THEN
			Q3 := E3;
			s3 := tx;
		END_IF;
		c := 0;
END_CASE;

(* revision history

hm 28. sep. 2008		rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
