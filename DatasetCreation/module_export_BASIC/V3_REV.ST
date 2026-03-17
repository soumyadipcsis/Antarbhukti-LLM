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

this function reverses a vector in a 3 dimensional space
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_REV

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_REV :	oscat_vector_3;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_REV
IEC_LANGUAGE: ST
*)
V3_REV.X := -A.X;
V3_REV.Y := -A.Y;
V3_REV.Z := -A.Z;

(* revision history
hm		11 dec 2007	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
