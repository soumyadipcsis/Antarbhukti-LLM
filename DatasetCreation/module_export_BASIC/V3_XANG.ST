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

this function calculates the angle between the X-axis and a vectors in a 3 dimensional space

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK V3_XANG

(*Group:Default*)


VAR_INPUT
	A :	oscat_vector_3;
END_VAR


VAR_OUTPUT
	V3_XANG :	REAL;
END_VAR


VAR
	la :	REAL;
	V3_ABS :	V3_ABS;
END_VAR


(*@KEY@: WORKSHEET
NAME: V3_XANG
IEC_LANGUAGE: ST
*)

V3_ABS(A:=A);
la:=V3_ABS.V3_ABS;

IF la > 0.0 THEN
	V3_XANG := ACOS(A.X / la);
ELSE
    V3_XANG := 0.0;
END_IF;

(* revision history
hm	11 dec 2007	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	changed syntax of real constants to 0.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
