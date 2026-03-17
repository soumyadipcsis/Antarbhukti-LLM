(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.DOUBLE_PRECISION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	20. mar. 2008
programmer 	hugo
tested by	tobias

R2_mul multiplies a real with a double real which extends the accuracy of a real to twice as many digits
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK R2_MUL

(*Group:Default*)


VAR_INPUT
	X :	REAL2;
	Y :	REAL;
END_VAR


VAR_OUTPUT
	R2_MUL :	REAL2;
END_VAR


(*@KEY@: WORKSHEET
NAME: R2_MUL
IEC_LANGUAGE: ST
*)
R2_MUL.RX := X.RX * Y;
R2_MUL.R1 := X.R1 * Y;


(* revision history
hm		20.3.2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
