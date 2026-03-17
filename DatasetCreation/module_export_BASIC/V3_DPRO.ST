(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.VEKTORMATHEMATIK
*)
(*@KEY@:DESCRIPTION*)
version 1.0	11 dec 2007
programmer 	hugo
tested by	tobias

this function calculates the dot product of two vectors in 3 dimensional space
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_DPRO

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
	B :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_DPRO :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_DPRO
IEC_LANGUAGE: ST
*)
V3_DPRO := A.X * B.X + A.Y * B.Y + A.Z * B.Z;

(* revision history
hm		11 dec 2007	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
