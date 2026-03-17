(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0	16. may. 2008
programmer 	hugo
tested by	tobias

Scale is used to translate an input x to output by the formula Y = X*K + O.
at the same time the output is limited to MN and MX.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	K :	REAL;
	O :	REAL;
	MX :	REAL;
	MN :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE
IEC_LANGUAGE: ST
*)
SCALE := LIMIT(MN, X * K + O, MX);

(* revision history
hm	16. may. 2008		rev 1.0
	original version
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
