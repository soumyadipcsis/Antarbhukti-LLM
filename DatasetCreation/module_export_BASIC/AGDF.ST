(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the inverse Gudermannian function.
(*@KEY@:END_DESCRIPTION*)
FUNCTION AGDF:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AGDF
IEC_LANGUAGE: ST
*)
AGDF := LN((1.0 + SIN(X)) / COS(X));

(* comment
the current implementation gives sufficient accuracy only up to X = 1.57 or an output > 10.
is X closer to PI/2 then the function is more and more unreliable
*)



(* revision history
hm	27. apr. 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	real constants updated to new systax using dot

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
