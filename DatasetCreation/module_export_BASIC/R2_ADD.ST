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

R2_add adds a real to a double real which extends the accuracy of a real to twice as many digits
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK R2_ADD

(*Group:Default*)


VAR_INPUT
	X :	REAL2;
	Y :	REAL;
END_VAR


VAR_OUTPUT
	R2_ADD :	REAL2;
END_VAR


VAR
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: R2_ADD
IEC_LANGUAGE: ST
*)
temp := X.RX;
R2_ADD.RX := Y + X.R1 + X.RX;
R2_ADD.R1 := temp - R2_ADD.RX + Y + X.R1;

(* revision history
hm		20.3.2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
