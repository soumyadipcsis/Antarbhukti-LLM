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

this function checks if two vectors in a 3 dimensional space are parallel.
which means the two vectors have the same direction
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_PAR

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
	B :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_PAR :	BOOL;
END_VAR


VAR
	V3_XPRO :	V3_XPRO;
	V3_ABS :	V3_ABS;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_PAR
IEC_LANGUAGE: ST
*)
V3_XPRO(A:=A,B:=B);
V3_ABS(A:=V3_XPRO.V3_XPRO);

V3_PAR := V3_ABS.V3_ABS = 0.0;



(* revision history
hm	11 dec 2007	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	changed syntax of real constants to 0.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
