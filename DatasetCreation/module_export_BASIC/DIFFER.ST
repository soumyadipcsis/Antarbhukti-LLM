(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16 mar 2008
programmer 	hugo
tested by	tobias

this function checks if in1 differs more then x from in2
the output is true if abs(in1-in2) > X
(*@KEY@:END_DESCRIPTION*)
FUNCTION DIFFER:BOOL

(*Group:Default*)


VAR_INPUT
	IN1 :	REAL;
	IN2 :	REAL;
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DIFFER
IEC_LANGUAGE: ST
*)
DIFFER := ABS(in1 - in2) > X;

(* revision history
hm		8. oct 2006		rev 1.0
	original version

hm		16. mar 2008	rev 1.1
	improverd code for performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
