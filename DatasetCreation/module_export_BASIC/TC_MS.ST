(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	13 mar 2008
programmer 	hugo
tested by	tobias

TC_MS delivers the time it was last called on the output TC in Milliseconds.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TC_MS

(*Group:Default*)


VAR_OUTPUT
	TC :	DWORD;
END_VAR


VAR
	init :	BOOL;
	tx :	UDINT;
	last :	UDINT;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TC_MS
IEC_LANGUAGE: ST
*)
(* read system time and prepare input data *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

IF NOT init THEN
	init := TRUE;
	TC := DWORD#0;
ELSE
	tc := UDINT_TO_DWORD(tx - last);
END_IF;
last := tx;

(* revision history
hm		13. mar. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
