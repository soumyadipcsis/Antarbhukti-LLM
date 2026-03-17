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

R2_add adds a double precision real to a double precision real which extends the accuracy of a real to twice as many digits
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK R2_ADD2

(*Group:Default*)


VAR_INPUT
	X :	REAL2;
	Y :	REAL2;
END_VAR


VAR_OUTPUT
	R2_ADD2 :	REAL2;
END_VAR


(*@KEY@: WORKSHEET
NAME: R2_ADD2
IEC_LANGUAGE: ST
*)
R2_ADD2.R1 := X.R1 + Y.R1;
R2_ADD2.RX := X.RX + Y.RX;


(* revision history
hm		20.3.2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
