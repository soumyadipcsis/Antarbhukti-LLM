(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	22. sep. 2008
programmer 	hugo
tested by	oscat

MANUAL_2 is a manual override for boolean signals.
it has static force high and low as well as a manual input.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MANUAL_2

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	ENA :	BOOL;
	ON :	BOOL;
	OFF :	BOOL;
	MAN :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	STATUS :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: MANUAL_2
IEC_LANGUAGE: ST
*)
IF ena THEN
	IF NOT ON AND NOT OFF THEN
		Q := IN;
		STATUS := BYTE#100;
	ELSIF on AND NOT off THEN
		Q := TRUE;
		STATUS := BYTE#101;
	ELSIF NOT on AND off THEN
		q := FALSE;
		STATUS := BYTE#102;
	ELSE
		Q := MAN;
		STATUS := BYTE#103;
	END_IF;
ELSE
	Q := FALSE;
	STATUS := BYTE#104;
END_IF;



(* revision history
hm	22. sep. 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
