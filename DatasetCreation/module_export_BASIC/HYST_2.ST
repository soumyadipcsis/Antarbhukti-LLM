(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.2	2. jun. 2008
programmer 	oscat
tested BY	tobias

this hysteresis function switches the output high if the input signal reaches obove val + hys/2 and will switch to low when the input falls back below val - hys/2 value.
a separate output mid is set if the input stays between low and high value.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HYST_2

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	VAL :	REAL;
	HYS :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	WIN :	BOOL;
END_VAR


VAR
	tmp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HYST_2
IEC_LANGUAGE: ST
*)
tmp := val - hys * 0.5;
IF in < tmp THEN
	Q := FALSE;
	win := FALSE;
ELSIF in > tmp + hys THEN
	Q := TRUE;
	win := FALSE;
ELSE
	win := TRUE;
END_IF;

(* code used for 1.2 and before
X := hys * 0.5;
IF Q THEN
	IF in < val - x THEN q := FALSE; END_IF;
ELSE
	IF in > val + x THEN q := TRUE; END_IF;
END_IF;
win := in > val - x AND in < val + x;
*)

(* revision history
hm		4. aug 2006	rev 1.0
	original version

hm		5. jan 2008	rev 1.1
	improved code for better performance

hm		2. jun. 2008	rev 1.2
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
