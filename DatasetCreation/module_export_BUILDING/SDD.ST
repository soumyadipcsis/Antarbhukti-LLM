(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.1	2 dec 2007
programmer 	hugo
tested by	tobias

this function calculates the vapor saturation pressure for moist Air over ice or water
(*@KEY@:END_DESCRIPTION*)
FUNCTION SDD:REAL

(*Group:Default*)


VAR_INPUT
	T :	REAL;
	ICE :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SDD
IEC_LANGUAGE: ST
*)
IF ice THEN
	SDD := 611.153 * EXP(22.4433 * T / (272.186 + T));
ELSE
	SDD := 611.213 * EXP(17.5043 * T / (241.2 + T));
END_IF;

(* old code used in rev 1.0
IF ice THEN
	SDD := 611.153 * exp10(9.747*T / (272.186 + T));
ELSE
	SDD := 611.213 * exp10(7.602*T / (241.2 + T));
END_IF;
*)


(* revision history

hm 29 oct 2007		rev 1.0
	original version

hm	2. dec 2007		rev 1.1
	changed code for better performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
