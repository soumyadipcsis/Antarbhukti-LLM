(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	11. mar 2008
programmer 	hugo
tested by	tobias

this function calculates the sin hyperbolicus
(*@KEY@:END_DESCRIPTION*)
FUNCTION SINH:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SINH
IEC_LANGUAGE: ST
*)
IF ABS(x) < 2.0E-3 THEN
	SINH := X;
ELSE
	SINH := (EXP(x) - EXP(-x)) * 0.5;
END_IF;


(* revision history
hm	12.1.2007	rev 1.0
	original version

hm	1.12.2007	rev 1.1
	changed code to improve performance

hm	5. jan 2008	rev 1.2
	further performance improvement

hm	11. mar 2008	rev 1.3
	improved accuracy around 0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
