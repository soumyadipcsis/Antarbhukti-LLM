(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.2		16 feb 2011
programmer 	    hugo
tested by		oscat

clk_pulse uses the internal sps time to generate a clock with programmable period time.
the period time is defined for 10ms .. 65s.
pulse generation is continuous if N = 0 and for n pulses otherwise.
the first cycle after start is a clk pulse and then depending on the programmed period time a delay.
every pulse is only valid for one cycle so that a edge trigger is not necessary
clk_prg depending on the accuracy of the system clock.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CLK_PULSE

(*Group:Default*)


VAR_INPUT
	PT :	TIME;
	N :	INT;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	CNT :	INT;
	RUN :	BOOL;
END_VAR


VAR
	tx :	UDINT;
	tn :	UDINT;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: CLK_PULSE
IEC_LANGUAGE: ST
*)
(* read system *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;
Q := FALSE;				(* reset Q we generate pulses only for one cycle *)
RUN := CNT < N;

IF NOT init OR RST THEN
	init := TRUE;
	CNT := 0;
	tn := tx - TIME_TO_UDINT(PT);
	RUN := FALSE;
ELSIF (cnt < N OR N = 0) AND tx - tn >= TIME_TO_UDINT(PT) THEN		(* generate a pulse *)
	CNT := CNT + 1;
	Q := TRUE;
	tn := tn + TIME_TO_UDINT(PT);
END_IF;

(* revision history
hm		4. aug 2006		rev 1.0
	original version

hm		17. sep 2007	rev 1.1
	replaced time() with T_PLC_S() for compatblity reasons

hm		16. feb. 2011	rev 1.2
	fixed an error when timer overflows 
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
