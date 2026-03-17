(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	tobias

Word_to_Range converts a Byte into a real between low and high.

(*@KEY@:END_DESCRIPTION*)
FUNCTION WORD_TO_RANGE:REAL

(*Group:Default*)


VAR_INPUT
	X :	WORD;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: WORD_TO_RANGE
IEC_LANGUAGE: ST
*)
WORD_TO_RANGE := (high - low) * _WORD_TO_REAL(X) * 0.00001525902189669640 + low;


(* revision history
hm	9. jan 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	improved code
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
