(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11 nov 2007
programmer 	hugo
tested by	tobias

sgn returns 0 when X = 0 , -1 when X < 1 and +1 when X > 1
(*@KEY@:END_DESCRIPTION*)
FUNCTION SGN:INT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SGN
IEC_LANGUAGE: ST
*)
IF X > 0.0 THEN
	sgn := 1;
ELSIF X < 0.0 THEN
	sgn := -1;
ELSE
	sgn := 0;
END_IF;

(* revision histroy
hm	16. oct 2007	rev 1.0
	original version

hm	11. nov 2007	rev 1.1
	changed type of function from real to int
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
