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
tested by	oscat

this function calculates the tanc function.

(*@KEY@:END_DESCRIPTION*)
FUNCTION TANC:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TANC
IEC_LANGUAGE: ST
*)
IF X = 0.0 THEN
	TANC := 1.0;
ELSE
	TANC := TAN(x) / x;
END_IF;


(* revision histroy
hm	23. oct. 2008	rev 1.0
	original version

hm 10. mar. 2009	rev 1.1
	real constants updated to new systax using dot																																																															
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																								

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
