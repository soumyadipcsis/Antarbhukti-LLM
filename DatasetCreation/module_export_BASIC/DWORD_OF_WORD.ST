(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0	18. jul. 2009
programmer 	hugo
tested by	tobias

this function creates a Dword from 2 individual Words
(*@KEY@:END_DESCRIPTION*)
FUNCTION DWORD_OF_WORD:DWORD

(*Group:Default*)


VAR_INPUT
	W1 :	WORD;
	W0 :	WORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: DWORD_OF_WORD
IEC_LANGUAGE: ST
*)
DWORD_OF_WORD := SHL_DWORD(WORD_TO_DWORD(W1),16) OR WORD_TO_DWORD(W0);


(* revision history

hm	18. jul. 2009	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
