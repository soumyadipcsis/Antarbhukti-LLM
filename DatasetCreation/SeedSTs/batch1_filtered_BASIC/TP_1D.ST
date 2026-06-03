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

TP_2 generates a pulse every time it is calles with in := TRUE.
the module will reset IN by itself so no clearing of in is necessary.
in addition the timer can be cleared asynchronously with rst.
also the rst input is cleared by the module itself.
the timer can be retriggered as often as necessary. it will count PT from the last trigger.
after the time PT1 is elapsed, the timer blocks itself for PT2 and only allow new sequences after PT2 has elapsed.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TP_1D

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	PT1 :	TIME;
	PTD :	TIME;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	W :	BOOL;
END_VAR


VAR
	tx :	TIME;
	start :	TIME;
	ix :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TP_1D
IEC_LANGUAGE: ST
*)
(* read system_time *)
T_PLC_MS();
tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF RST THEN
	Q := FALSE;
	rst := FALSE;
	W := FALSE;
ELSIF W THEN
	IF tx - start >= PTD THEN
		W := FALSE;
	END_IF;
ELSIF IN AND NOT ix THEN
	Q := TRUE;
	start := tx;
	in := FALSE;
ELSIF tx - start >= PT1 THEN
	Q := FALSE;
	W := TRUE;
	start := tx;
END_IF;

ix := IN;



(* revision history
hm	28. jun. 2008
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
