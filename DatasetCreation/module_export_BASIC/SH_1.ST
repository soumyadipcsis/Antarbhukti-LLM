(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.2	17 sep 2007
programmer 	hugo
tested by	tobias

this sample and hold module samples an input every PT seconds.
after a ample is taken the output Trig will be active for one cycle.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SH_1

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	PT :	TIME;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
	TRIG :	BOOL;
END_VAR


VAR
	last :	TIME;
	tx :	TIME;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: SH_1
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF tx - last >= PT THEN
	last := tx;
	out := in;
	trig := TRUE;
ELSE
	trig := FALSE;
END_IF;

(* revision history

HM	6.1.2007	rev 1.1
	added trig output

HM	17.9.2007	rev 1.2
	replaced time() with T_PLC_MS() for compatibility reasons
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
