(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	22. jan. 2009
programmer 	hugo
tested by	oscat

this function converts degrees, minutes seconds to decimal degrees.
(*@KEY@:END_DESCRIPTION*)
FUNCTION GEO_TO_DEG:REAL

(*Group:Default*)


VAR_INPUT
	D :	INT;
	M :	INT;
	SEC :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: GEO_TO_DEG
IEC_LANGUAGE: ST
*)
GEO_TO_DEG := INT_TO_REAL(D) + INT_TO_REAL(M) * 0.016666666666667 + sec * 0.00027777777777778;


(* revision histroy
hm	22. jan. 2009	rev 1.0
	original release


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
