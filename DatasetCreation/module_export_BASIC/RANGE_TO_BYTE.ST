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
tested by		tobias

Range_to_byte converts a real value between low and high into a byte
(*@KEY@:END_DESCRIPTION*)
FUNCTION RANGE_TO_BYTE:BYTE

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: RANGE_TO_BYTE
IEC_LANGUAGE: ST
*)
Range_to_Byte := REAL_TO_BYTE(TRUNC_REAL((LIMIT(low,X,high)-low) * 255.0 / (high - low)));

(* revision history
hm	9. jan 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
