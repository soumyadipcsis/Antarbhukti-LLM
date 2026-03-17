(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. mar. 2011
programmer 	hugo
tested by	tobias

this function returns the lowest of 3 real values
(*@KEY@:END_DESCRIPTION*)
FUNCTION MIN3:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	REAL;
	IN2 :	REAL;
	IN3 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MIN3
IEC_LANGUAGE: ST
*)
MIN3 := MIN(MIN(IN1,IN2),IN3);

(* revision history
hm	1.1.2007	rev 1.0
	original release

hm	18. mar. 2011	rev 1.1
	improve performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
