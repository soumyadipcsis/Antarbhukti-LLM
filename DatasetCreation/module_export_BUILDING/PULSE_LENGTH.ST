(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	15 sep 2007
programmer 	oscat
tested by		tobias

Pulse_length indicates on 3 outputs if an input pulse had been shorter than T_short (short = True), longer than T_long (long = True) or between T_short and T_long (middle = True).
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PULSE_LENGTH

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	T_SHORT :	TIME := T#100ms;
	T_LONG :	TIME := T#1s;
END_VAR


VAR_OUTPUT
	SHORT :	BOOL;
	MIDDLE :	BOOL;
	LONG :	BOOL;
END_VAR


VAR
	tx :	TIME;
	tn :	TIME;
	edge :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: PULSE_LENGTH
IEC_LANGUAGE: ST
*)
(* read system time *)

T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* reset outputs, they should only be active 1 cycle *)
short := FALSE;
Middle := FALSE;
long := FALSE;

(* detect rising edge *)
IF in AND NOT edge THEN
	edge := TRUE;
	tn := tx;

(* detect for falling edge *)
ELSIF NOT in AND edge THEN
	edge := FALSE;
	tn := tx - tn;
	IF tn < t_short THEN
		short := TRUE;
	ELSIF tn > t_long THEN
		long := TRUE;
	ELSE
		Middle := TRUE;
	END_IF;

(* generate long pulse as soon as T_long is reached *)
ELSIF in AND tx - tn > t_long THEN
	long := TRUE;
END_IF;


(* revision history

hm	15. feb 2006	rev 1.0
	original version

hm	15 sep 2007		rev 1.1
	replaced Time() with T_PLC_MS for compatibility and performance reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
