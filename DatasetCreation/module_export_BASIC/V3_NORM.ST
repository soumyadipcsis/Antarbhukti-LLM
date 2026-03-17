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

this function generates a vectors with absolute length 1 from a vector A in a 3 dimensional space

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_NORM

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_NORM :	oscat_vector_3;
END_VAR


VAR
	la :	REAL;
	V3_SMUL :	V3_SMUL;
	V3_ABS :	V3_ABS;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_NORM
IEC_LANGUAGE: ST
*)

V3_ABS(A:=A);
la:=V3_ABS.V3_ABS;

IF la > 0.0 THEN
    V3_SMUL(A:=A,M:=1.0/la);
    V3_NORM:=V3_SMUL.V3_SMUL;
ELSE
    V3_NORM.X := 0.0;
    V3_NORM.Y := 0.0;
    V3_NORM.Z := 0.0;
END_IF;

(* revision history
hm	11 dec 2007	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	changed syntax of real constants to 0.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
