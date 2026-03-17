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

This function calculates the result of 1 / X
(*@KEY@:END_DESCRIPTION*)
FUNCTION INV:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: INV
IEC_LANGUAGE: ST
*)
IF X <> 0.0 THEN INV := 1.0 / X; END_IF;




(* revision history
hm	26. oct. 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	real constants updated to new systax using dot

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
