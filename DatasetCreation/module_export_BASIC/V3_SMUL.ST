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

this function multiplies a vectors in a 3 dimensional space with a skalar M
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_SMUL

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
	M :	REAL;
END_VAR


VAR_OUTPUT
	V3_SMUL :	oscat_vector_3;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_SMUL
IEC_LANGUAGE: ST
*)
V3_SMUL.X := A.X * M;
V3_SMUL.Y := A.Y * M;
V3_SMUL.Z := A.Z * M;

(* revision history
hm		11 dec 2007	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
