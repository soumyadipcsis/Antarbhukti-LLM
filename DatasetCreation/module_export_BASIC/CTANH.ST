(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.COMPLEX
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	oscat

this function calculates the complex hyperbolictangens

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CTANH

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CTANH :	oscat_complex;
END_VAR


VAR
	xi2 :	REAL;
	xr2 :	REAL;
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CTANH
IEC_LANGUAGE: ST
*)
xi2 := 2.0 * x.im;
xr2 := 2.0 * x.re;
temp := 1.0 /(COSH(xr2) + COS(xi2));
CTANH.re := temp * SINH(xr2);
CTANH.im := temp * SIN(xi2);


(* revision history
hm	21. feb 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1	
	new faster code

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
