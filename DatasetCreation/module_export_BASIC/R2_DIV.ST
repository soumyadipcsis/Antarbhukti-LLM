(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.DOUBLE_PRECISION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	8. mar. 2010
programmer 	hugo
tested by	tobias

R2_div divides a double real by a single real.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK R2_DIV

(*Group:Default*)


VAR_INPUT
	X :	REAL2;
	Y :	REAL;
END_VAR


VAR_OUTPUT
	R2_DIV :	REAL2;
END_VAR


(*@KEY@: WORKSHEET
NAME: R2_DIV
IEC_LANGUAGE: ST
*)
R2_DIV.RX := X.RX / Y;
R2_DIV.R1 := X.R1 / Y;


(* revision history
hm	8. mar. 2010	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
