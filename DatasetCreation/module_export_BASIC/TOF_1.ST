(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	17. jul. 2008
programmer 	hugo
tested by	oscat

TOF_1 will extend a pulse on input in for PT seconds.
in addition the timer can be cleared asynchronously with rst.
TOF_1 is the same function as TOF from the standard LIB except the asynchronous reset input.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TOF_1

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	PT :	TIME;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	start :	TIME;
	tx :	TIME;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TOF_1
IEC_LANGUAGE: ST
*)
(* read system timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF RST THEN
	Q := FALSE;
ELSIF IN THEN
	Q := TRUE;
	start := tx;
ELSIF tx - start >= PT THEN
	Q := FALSE;
END_IF;

(* revision history
hm	17. jul. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
