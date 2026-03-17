(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	4. apr. 2008
programmer 	hugo
tested by	tobias

This is a rounding function which returns the biggest possible integer which is less or equal to X.
floor2(3.14) = 3
floor2(-3.14) = -4
(*@KEY@:END_DESCRIPTION*)
FUNCTION FLOOR2:DINT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FLOOR2
IEC_LANGUAGE: ST
*)
FLOOR2 := _REAL_TO_DINT(X);
IF DINT_TO_REAL(FLOOR2) > X THEN
	FLOOR2 := FLOOR2 - DINT#1;
END_IF;

(* revision history
hm	21. mar. 2008	rev 1.0
	originlal version

hm	4. apr. 2008	rev 1.1
	added type conversion to avoid warnings under codesys 3.0
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
