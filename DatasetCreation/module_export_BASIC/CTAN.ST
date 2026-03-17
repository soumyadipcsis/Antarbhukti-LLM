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

this function calculates the tangens function of a complex number

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CTAN

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
END_VAR


VAR_OUTPUT
	CTAN :	oscat_complex;
END_VAR


VAR
	temp :	REAL;
	xi2 :	REAL;
	xr2 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CTAN
IEC_LANGUAGE: ST
*)
xi2 := 2.0 * x.im;
xr2 := 2.0 * x.re;
temp := 1.0 / (COS(xr2) + COSH( xi2));
CTAN.re := temp * SIN(xr2);
CTAN.im := temp * SINH(xi2);


(* revision history
hm	21. feb 2008	rev 1.0
	original version

hm	10. mar 2009	rev 1.1
	faster code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
