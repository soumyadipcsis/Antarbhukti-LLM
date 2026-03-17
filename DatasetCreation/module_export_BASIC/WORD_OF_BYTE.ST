(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.4	18. jul. 2009
programmer 	hugo
tested by	tobias

this function creates a word from 2 individual bytes
(*@KEY@:END_DESCRIPTION*)
FUNCTION WORD_OF_BYTE:WORD

(*Group:Default*)


VAR_INPUT
	B1 :	BYTE;
	B0 :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: WORD_OF_BYTE
IEC_LANGUAGE: ST
*)
WORD_OF_BYTE := SHL_WORD(BYTE_TO_WORD(B1),8) OR BYTE_TO_WORD(B0);

(* revision history
hm	24. jan 2007	rev 1.0
	original version

hm	2. jan 2008	rev 1.1
	improved performance

hm	19. feb 2008	rev 1.2
	replaced and with or for better compatibility

hm	23. apr. 2008	rev 1.3
	reverse order of inputs to be more logical

hm	18. jul. 2009	rev 1.4
	added type conversions for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
