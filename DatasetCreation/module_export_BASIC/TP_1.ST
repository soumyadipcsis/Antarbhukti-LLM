(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	28. jun. 2008
programmer 	hugo
tested by	oscat

TP_1 generates a pulse every time it is calles with in := TRUE.
in addition the timer can be cleared asynchronously with rst.
the timer can be retriggered as often as necessary. it will count PT from the last trigger.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TP_1

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
	tx :	TIME;
	start :	TIME;
	ix :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TP_1
IEC_LANGUAGE: ST
*)
(* read system timer *)
(* read system_time *)
T_PLC_MS();
tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF RST THEN
	Q := FALSE;
ELSIF IN AND NOT ix THEN
	Q := TRUE;
	start := tx;
ELSIF tx - start >= PT THEN
	Q := FALSE;
END_IF;

ix:= IN;



(* revision history
hm	28. jun. 2008
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
