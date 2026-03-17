(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the Gudermannian function.
(*@KEY@:END_DESCRIPTION*)
FUNCTION GDF:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: GDF
IEC_LANGUAGE: ST
*)
IF X = 0.0 THEN
	GDF := 0.0;
ELSIF X > 15.0 THEN
	GDF := 1.5707963267949;
ELSIF X < -15.0 THEN
	GDF := -1.5707963267949;
ELSE
	GDF := ATAN(EXP(X)) * 2.0 - 1.5707963267949;
END_IF;

(* revision history
hm	27. apr. 2008	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	using math constants

hm	10. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
