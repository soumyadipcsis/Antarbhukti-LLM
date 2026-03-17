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

R2_abs returns the absulute value of a double precision real.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK R2_ABS

(*Group:Default*)


VAR_INPUT
	X :	REAL2;
END_VAR


VAR_OUTPUT
	R2_ABS :	REAL2;
END_VAR


(*@KEY@: WORKSHEET
NAME: R2_ABS
IEC_LANGUAGE: ST
*)
IF X.RX >= 0.0 THEN
	R2_ABS.RX := X.RX;
	R2_ABS.R1 := X.R1;
ELSE
	R2_ABS.RX := -X.RX;
	R2_ABS.R1 := -X.R1;
END_IF;


(* revision history
hm	21. mar. 2008	rev 1.0
	original version

hm	10. mar. 2009 rev 1.1
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
