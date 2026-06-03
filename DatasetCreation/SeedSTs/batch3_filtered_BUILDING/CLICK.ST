(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 2.0	28. dec. 2008
programmer 	oscat
tested by	oscat

click checks an input for single, double or tripple click and sets the corresponding output single, doulbe or triple for the time the input stays high at the last click.
the maximum high and low time for a click can be configured with setup variables.
the input configures itself to be high or low active depending on which state the input stays longer than t_reconfig.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CLICK

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	T_DEBOUNCE :	TIME := T#10ms;
	T_SHORT :	TIME := T#200ms;
	T_PAUSE :	TIME := T#500ms;
	T_RECONFIG :	TIME := T#1m;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	SINGLE :	BOOL;
	DOUBLE :	BOOL;
	TRIPLE :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	s_in :	SW_RECONFIG;
	tx :	TIME;
	state :	INT;
	last :	TIME;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: CLICK
IEC_LANGUAGE: ST
*)
(* reconfiguration and debounce circuitry *)
s_in(in := in, TD := T_debounce, TR := T_reconfig);

(* read system time *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* count the mumber of clicks *)
IF s_in.Q XOR Q THEN
	last := tx;
	IF s_in.Q THEN state := state + 1; END_IF;
END_IF;
Q := s_in.Q;

(* set outputs *)
IF state > 0 THEN
	IF (Q AND tx - last > t_short) OR (NOT Q AND tx - last > t_pause) THEN
		CASE state OF
			1:	single := TRUE;
				status := BYTE#111;
			2:	double := TRUE;
				status := BYTE#112;
			3:	triple := TRUE;
				status := BYTE#113;
		END_CASE;
		state := 0;
	END_IF;
ELSIF NOT q THEN
	single := FALSE;
	double := FALSE;
	triple := FALSE;
	status := BYTE#110;
	last := tx;
	state := 0;
END_IF;

(* revision history

15 Feb 2007	rev 1.0	hm
	created original version

18.5.2007	rev 1.1 hm
	corrected an error while execution would stop after t_reconfig elapsed.

15.9.2007	rev 1.2 hm
	replaced Time() with T_PLC_MS for compatibility and performance reasons

28. dec. 2008	rev 2.0
	rewritten using modular approach

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
