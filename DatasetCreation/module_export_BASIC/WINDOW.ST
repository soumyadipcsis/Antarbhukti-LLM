(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
	version 1.1	22 jan 2007
	programmer 	hugo
	tested BY	tobias

this checks a signal if the signal is between the upper and lower limit
(*@KEY@:END_DESCRIPTION*)
FUNCTION WINDOW:BOOL

(*Group:Default*)


VAR_INPUT
	LOW :	REAL;
	IN :	REAL;
	HIGH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: WINDOW
IEC_LANGUAGE: ST
*)
window := (in < high) AND (in > low);

(* revision history
hm	22.1.2007	rev 1.1
	changed the order of inputs to low, in, high

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
