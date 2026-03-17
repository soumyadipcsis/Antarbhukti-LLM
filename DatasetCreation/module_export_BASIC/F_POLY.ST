(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. mar. 2011
programmer 	hugo
tested by	tobias

this function calculates the polynom C[0] + C[1]*X^1 + C[2]*X^2 * C[3]*X^3 + C[4]*X^4 + C[5]*X^5 + C[6]*X^6 + C[7]*X^7

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK F_POLY

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	C :	oscat_arr_0_7;
END_VAR


VAR_OUTPUT
	F_POLY :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_POLY
IEC_LANGUAGE: ST
*)
F_POLY := ((((((( c[7] * x + c[6] ) * x + c[5] ) * x + c[4] ) * x + c[3] ) * x + c[2] ) * x + c[1] ) * x + c[0] ) ;

(* revision history
hm		20. may. 2008		rev 1.0
	original version

hm	18. mar. 2011	rev 1.1
	improved performance
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
