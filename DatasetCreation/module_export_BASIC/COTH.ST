(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.4	10. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the cotangens hyperbolicus
(*@KEY@:END_DESCRIPTION*)
FUNCTION COTH:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: COTH
IEC_LANGUAGE: ST
*)
IF X > 20.0 THEN
	COTH :=1.0;
ELSIF X < -20.0 THEN
	COTH := -1.0;
ELSE
	COTH := 1.0 + 2.0 / (EXP(X * 2.0) - 1.0);
END_IF;

(* revision histroy
hm		12.1.2007	rev 1.0
	original version

hm	1.12.2007		rev 1.1
	changed code to improve performance

hm	8. jan 2008	rev 1.2
	further improvement in performance

hm	10. mar 2008	rev 1.3
	extended range of valid inputs to +/- INV
	changed formula for better accuracy

hm	10. mar. 2009	rev 1.4
	real constants updated to new systax using dot
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
