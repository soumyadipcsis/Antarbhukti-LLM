(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	17. dec. 2008
programmer 	hugo
tested by	oscat

retriggerable edge triggered pulse similar to TP but with a retrigger function
if the pt input is 0 then output is always low.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TP_X

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	PT :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	ET :	TIME;
END_VAR


VAR
	edge :	BOOL;
	start :	TIME;
	tx :	TIME;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TP_X
IEC_LANGUAGE: ST
*)
(* read system_time *)
T_PLC_MS();
tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* rising edge trigger *)
IF IN AND NOT edge THEN
	start := tx;
	Q := PT > t#0ms;
ELSIF Q THEN
	ET := tx - start;
	IF ET >= PT THEN
		Q := FALSE;
		ET := t#0ms;
	END_IF;
END_IF;
edge := IN;

(* revision history
hm	4. aug 2006		rev 1.0
	original version

hm	17. sep 2007	rev 1.1
	replaced time() with T_PLC_MS() for compatibility reasons

hm	19. oct. 2008	rev 1.2
	renamed to TP_R to TP_X for compatibility reasons

hm	17. dec. 2008	rev 1.3
	code optimized

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
