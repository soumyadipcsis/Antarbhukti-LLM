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

this function adds two vectors in a 3 dimensional space
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_XPRO

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
	B :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_XPRO :	oscat_vector_3;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_XPRO
IEC_LANGUAGE: ST
*)
V3_XPRO.X := A.Y * B.Z - A.Z * B.Y;
V3_XPRO.Y := A.Z * B.X - A.X * B.Z;
V3_XPRO.Z := A.X * B.Y - A.Y * B.X;

(* revision history
hm		11 dec 2007	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
