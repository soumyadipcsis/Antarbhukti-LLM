(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar 2009
programmer 	hugo
tested by	tobias

this function calculates the arcus sin hyperbolicus
(*@KEY@:END_DESCRIPTION*)
FUNCTION ASINH:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ASINH
IEC_LANGUAGE: ST
*)
ASINH := LN(SQRT(X * X + 1.0)+X);

(* revision history
hm		12 jan 2007	rev 1.0
	original version

hm		2. dec 2007	rev 1.1
	changed code for better performance

hm		16.3. 2007		rev 1.2
	changed sequence of calculations to improve performance

hm	10. mar. 2009		rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
