(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
	version 1.0	31 oct 2007
	programmer 	hugo
	tested BY	tobias

this checks a signal if the signal is between the upper and lower limit including the two limits
(*@KEY@:END_DESCRIPTION*)
FUNCTION WINDOW2:BOOL

(*Group:Default*)


VAR_INPUT
	LOW :	REAL;
	IN :	REAL;
	HIGH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: WINDOW2
IEC_LANGUAGE: ST
*)
window2 := (in <= high) AND (in >= low);

(* revision history
hm	31.10.2007	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
