(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	20. jul. 2008
programmer 	hugo
tested by	oscat

Q of tmax will follow IN except that it forces a maximum ontime for the output Q.
the output Z will be active for one cycle if the output is forced low by the timeout.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TMAX

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	PT :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	Z :	BOOL;
END_VAR


VAR
	tx :	TIME;
	start :	TIME;
	last_in :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TMAX
IEC_LANGUAGE: ST
*)
(* read system timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

Z := FALSE;

IF NOT in THEN
	Q := FALSE;
ELSIF IN AND NOT last_in THEN
	Q := TRUE;
	start := tx;
ELSIF (tx - start >= PT) AND Q THEN
	Q := FALSE;
	Z := TRUE;
END_IF;

last_in := IN;

(* revision history
hm	20. jul. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
