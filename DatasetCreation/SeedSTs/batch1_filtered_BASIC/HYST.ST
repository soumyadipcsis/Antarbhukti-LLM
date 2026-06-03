(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	2. jun. 2008
programmer 	hugo
tested BY	tobias

This Hystereses function has two modes:
1. if on > off then Q will be switched high when in > on and switched low when in < off.
2. if on < off then Q will be switched high when in < on and switched low when in > off.
the output win will be high when in is between low and high.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HYST

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	ON :	REAL;
	OFF :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	WIN :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HYST
IEC_LANGUAGE: ST
*)
IF ON >= OFF THEN
	IF IN < OFF THEN
		Q := FALSE;
		WIN := FALSE;
	ELSIF  IN > ON THEN
		Q := TRUE;
		WIN := FALSE;
	ELSE
		WIN := TRUE;
	END_IF;
ELSE
	IF IN > OFF THEN
		Q := FALSE;
		WIN := FALSE;
	ELSIF  IN < ON THEN
		Q := TRUE;
		WIN := FALSE;
	ELSE
		WIN := TRUE;
	END_IF;
END_IF;

(* revision history
hm		2.  jun 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
