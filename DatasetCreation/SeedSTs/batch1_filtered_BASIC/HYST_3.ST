(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.2	5 jan 2008
programmer 	oscat
tested BY	tobias

this is a double hysteresis function. Out1 follows a hysteresis function defined by val1and hyst, while out 2 follows val2 and hyst.
if the input signal is between the two hysteresis switches (val1 and val2) then non of the outputs is active.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HYST_3

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	HYST :	REAL;
	VAL1 :	REAL;
	VAL2 :	REAL;
END_VAR


VAR_OUTPUT
	Q1 :	BOOL;
	Q2 :	BOOL;
END_VAR


VAR
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HYST_3
IEC_LANGUAGE: ST
*)
X := hyst * 0.5;
IF in < val1 - X THEN
	q1 := TRUE;
ELSIF in > val1 + X THEN
	q1 := FALSE;
END_IF;
IF in < val2 - X THEN
	q2 := FALSE;
ELSIF in > val2 + X THEN
	q2 := TRUE;
END_IF;

(* revision history
hm	22. jan 2007	rev 1.0
	original version

hm	27. dec 2007	rev 1.1
	changed code for better performance

hm	5. jan 2008		rev 1.2
	further performance iprovements

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
