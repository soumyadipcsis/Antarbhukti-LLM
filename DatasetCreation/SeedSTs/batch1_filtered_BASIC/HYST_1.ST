(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	2. jun. 2008
programmer 	hugo
tested BY	tobias

this hysteresis function switches the output high if the input signal reaches obove high and will switch to low when the input falls back below low value.
a separate output mid is set if the input stays between low and high value.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HYST_1

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	HIGH :	REAL;
	LOW :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	WIN :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HYST_1
IEC_LANGUAGE: ST
*)
IF in < low THEN
	Q := FALSE;
	win := FALSE;
ELSIF in > high THEN
	Q := TRUE;
	win := FALSE;
ELSE
	win := TRUE;
END_IF;

(* code used for rev 1.0
IF Q THEN
	IF in < low THEN q := FALSE; END_IF;
ELSE
	IF in > high THEN q := TRUE; END_IF;
END_IF;
win := in > low AND in < high;
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
