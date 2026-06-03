(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	13. nov. 2008
programmer 	oscat
tested by	hugo

click_mode decodes an input for single, double or long click and sets the corresponding output single, doulbe or long.
the input configures itself to be high or low active depending on which state the input stays longer than t_reconfig.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CLICK_MODE

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	T_LONG :	TIME := T#500ms;
END_VAR


VAR_OUTPUT
	SINGLE :	BOOL;
	DOUBLE :	BOOL;
	LONG :	BOOL;
	TP_LONG :	BOOL;
END_VAR


VAR
	Timer :	TP;
	cnt :	INT;
	last :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CLICK_MODE
IEC_LANGUAGE: ST
*)
(* when input goes high start the timer to decode pulses *)
timer(in := IN, PT := T_LONG);
single := FALSE;
double := FALSE;

IF timer.Q THEN
	(* decode pulses while the timer is active *)
	IF NOT in AND last THEN	cnt := cnt + 1; END_IF;
ELSE
	CASE cnt OF
		1 : single := TRUE;
		2 : double := TRUE;
	END_CASE;
	cnt := 0;
END_IF;
last := in;
TP_LONG := NOT timer.Q AND (NOT LONG) AND IN;
LONG := NOT timer.Q AND in;




(* revision history

hm	13. nov. 2008	rev 1.0
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
