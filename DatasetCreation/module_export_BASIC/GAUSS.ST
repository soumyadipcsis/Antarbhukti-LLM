(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the gaussian density function

(*@KEY@:END_DESCRIPTION*)
FUNCTION GAUSS:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	U :	REAL;
	SI :	REAL;
END_VAR


VAR
	temp :	REAL;
	si_inv :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: GAUSS
IEC_LANGUAGE: ST
*)
temp := X - U;
si_inv := 1.0  / si;
GAUSS := EXP(Temp * Temp * si_inv * SI_inv * - 0.5) * 0.39894228 * si_inv;



(* revision hisdtory
hm	6. apr. 2008	rev 1.0
	original version

hm	27. oct. 2008	rev 1.1
	optimized performance	

hm	10. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
