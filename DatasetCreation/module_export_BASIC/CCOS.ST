(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.COMPLEX
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21 feb 2008
programmer 	hugo
tested by	oscat

this function calculates the cosinus function of a complex number
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CCOS

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CCOS :	oscat_complex;
END_VAR


VAR
	CSET :	CSET;
	CCOSH :	CCOSH;
END_VAR


(*@KEY@: WORKSHEET
NAME: CCOS
IEC_LANGUAGE: ST
*)
CSET(RE:= -X.im,IM:=X.re);
CCOSH(X:=CSET.CSET);
CCOS := CCOSH.CCOSH;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
