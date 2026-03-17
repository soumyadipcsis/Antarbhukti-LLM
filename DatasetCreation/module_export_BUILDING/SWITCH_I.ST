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

this is an intelligent switch interface which has an autodetect feature for in and it will detect the type of switch connected automatically
the input can be connected to low active pulses, high active pulses and on/off switch.
it will automatically adjust to the correct type without manual adjustment
a configurable debounce timer will debounce input signals
if t_on_max is set to anything other then 0 the output will be turned off after the max on time is reached.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SWITCH_I

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	IN :	BOOL;
	RST :	BOOL;
	T_DEBOUNCE :	TIME := T#10ms;
	T_RECONFIG :	TIME := T#1s;
	T_ON_MAX :	TIME := T#0h;
END_VAR


VAR_OUTPUT
	Q :	BOOL := FALSE;
END_VAR


VAR
	state :	BYTE := BYTE#0;
	edge :	BOOL := FALSE;
	r_edge :	BOOL := FALSE;
	T_on :	TIME;
	tx :	TIME;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: SWITCH_I
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* asynchronous set and reset first *)
IF set AND NOT rst THEN
	Q := TRUE;
	T_on := tx;
ELSIF rst THEN
	Q := FALSE;
(* check FOR input edge AND start debounce timer *)
ELSIF (in XOR edge) AND NOT (state = BYTE#1) THEN
	state := BYTE#1;
	T_on := Tx;
(* edge was detected and debounce time elapsed *)
ELSIF (state = BYTE#1) AND (Tx - t_debounce >= T_on) THEN
	state := BYTE#2;
	(* react on rising or falling edge depending on r_edge *)
	IF r_edge XOR in THEN Q := NOT Q; END_IF;
(* wait for T_reconfig and adjust r_edge *)
ELSIF state = BYTE#2 AND Tx - t_reconfig >= T_on THEN
	r_edge := in;
END_IF;
IF Q AND T_on_max > t#0ms AND Tx >= T_on + T_on_max THEN
	Q := FALSE;
END_IF;
edge := in;


(* revision history

hm	4 aug 2006	rev 1.0
	original version

hm	15.9.2007	rev 1.1
	replaced Time() with T_PLC_MS for compatibility and performance reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
