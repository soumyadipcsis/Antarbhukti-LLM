(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.VEKTORMATHEMATIK
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	tobias

this function checks if a vectors in a null Vector
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_NUL

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_NUL :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_NUL
IEC_LANGUAGE: ST
*)
V3_NUL := A.X = 0.0 AND A.Y = 0.0 AND A.Z = 0.0;



(* revision history
hm	12 dec 2007	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	changed syntax of real constants to 0.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
