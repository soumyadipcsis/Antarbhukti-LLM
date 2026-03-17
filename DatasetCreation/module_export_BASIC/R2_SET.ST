(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.DOUBLE_PRECISION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	tobias

R2_set sets a double precision real to a single real value.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK R2_SET

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


VAR_OUTPUT
	R2_SET :	REAL2;
END_VAR


(*@KEY@: WORKSHEET
NAME: R2_SET
IEC_LANGUAGE: ST
*)
R2_SET.RX := X;
R2_SET.R1 := 0.0;


(* revision history
hm	2. jun. 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
