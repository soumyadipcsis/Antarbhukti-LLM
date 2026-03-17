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

Range_to_word converts a real value between low and high into a byte
(*@KEY@:END_DESCRIPTION*)
FUNCTION RANGE_TO_WORD:WORD

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: RANGE_TO_WORD
IEC_LANGUAGE: ST
*)
Range_to_Word := REAL_TO_WORD(TRUNC_REAL((LIMIT(low,X,high)-low) * 65535.0 / (high - low)));


(* revision history
hm	9. jan 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
