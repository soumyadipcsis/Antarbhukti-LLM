(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0	9. jan 2008
programmer 	hugo
tested by	tobias

Byte_to_Range converts a Byte into a real between low and high.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BYTE_TO_RANGE:REAL

(*Group:Default*)


VAR_INPUT
	X :	BYTE;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: BYTE_TO_RANGE
IEC_LANGUAGE: ST
*)
Byte_to_Range := (high - low) * _BYTE_TO_REAL(X) / 255.0 + low;

(* revision history
hm	9. jan 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
