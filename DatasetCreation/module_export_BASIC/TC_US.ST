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

TC_US delivers the time it was last called on the output TC in Microseconds.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TC_US

(*Group:Default*)


VAR_OUTPUT
	TC :	DWORD;
END_VAR


VAR
	init :	BOOL;
	tx :	UDINT;
	last :	UDINT;
	T_PLC_US :	T_PLC_US;
END_VAR


(*@KEY@: WORKSHEET
NAME: TC_US
IEC_LANGUAGE: ST
*)
(* read system time and prepare input data *)
T_PLC_US();
tx:= T_PLC_US.T_PLC_US;

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
