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

this function calculates the angle between two vectors in a 3 dimensional space

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_ANG

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
	B :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_ANG :	REAL;
END_VAR


VAR
	d :	REAL;
	V3_ABS :	V3_ABS;
	V3_DPRO :	V3_DPRO;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_ANG
IEC_LANGUAGE: ST
*)

V3_ABS(A:=A);
d :=V3_ABS.V3_ABS;

V3_ABS(A:=B);
d := d * V3_ABS.V3_ABS;

IF d > 0.0 THEN
    V3_DPRO(A:=A,B:=B);
	V3_ANG := ACOS(LIMIT(-1.0, V3_DPRO.V3_DPRO / d,1.0));
ELSE
    V3_ANG := 0.0;

END_IF;

(* revision history
hm	11. dec. 2007	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	changed syntax of real constants to 0.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
