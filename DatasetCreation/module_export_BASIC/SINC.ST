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

this function calculates the sinc function.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SINC:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SINC
IEC_LANGUAGE: ST
*)
IF X = 0.0 THEN
	SINC := 1.0;
ELSE
	SINC := SIN(x) / x;
END_IF;


(* revision histroy
hm	11. mar. 2008	rev 1.0
	original version

hm	1.12.2007	rev 1.1
	changed code to improove performance

hm 10. mar. 2009	rev 1.2
	real constants updated to new systax using dot																																																															
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																								

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
