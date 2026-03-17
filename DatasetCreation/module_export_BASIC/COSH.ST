(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the cos hyperbolicus

(*@KEY@:END_DESCRIPTION*)
FUNCTION COSH:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


VAR
	t :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: COSH
IEC_LANGUAGE: ST
*)
T := EXP(X);
COSH := (1.0 / T + T) * 0.5;

(* revision histroy
hm	12.1.2007	rev 1.0
	original version

hm	1.12.2007	rev 1.1
	changed code to improve performance

hm	5. jan 2008	rev 1.2
	further performance improvement

hm	10. mar. 2009	rev 1.3
	real constants updated to new systax using dot
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
