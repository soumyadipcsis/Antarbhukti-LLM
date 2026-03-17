(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	29. jun. 2008
programmer 	hugo
tested by	oscat

sequence generates a sequence of states with a programmable length for each state.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SEQUENCE_64

(*Group:Default*)


VAR_INPUT
	START :	BOOL;
	SMAX :	INT;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	STATE :	INT := INT#-1;
	TRIG :	BOOL;
END_VAR


VAR_IN_OUT
	PROG :	oscat_array64_time;
END_VAR


VAR
	T_PLC_MS :	T_PLC_MS;
	tx :	TIME;
	last :	TIME;
	edge :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SEQUENCE_64
IEC_LANGUAGE: ST
*)
(* read system timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
TRIG := FALSE;

IF RST THEN
	STATE := -1;

(* start sequence *)
ELSIF START AND NOT edge THEN
	STATE := 0;
	last := tx;
	TRIG := TRUE;

(* sequence generator *)
ELSIF (STATE >= 0) THEN
	IF (tx - last) >= PROG[STATE] THEN
		STATE := INC2(STATE, 1, -1, SMAX);
		last := tx;
		TRIG := TRUE;
	END_IF;
END_IF;

edge := START;



(* revision history
hm	29. jun. 2008
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
