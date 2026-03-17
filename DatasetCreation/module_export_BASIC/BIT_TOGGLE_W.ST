(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0 18. oct. 2008
programmer 	hugo
tested by	tobias

this function toggles a bit of a WORD at position pos.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BIT_TOGGLE_W:WORD

(*Group:Default*)


VAR_INPUT
	IN :	WORD;
	POS :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIT_TOGGLE_W
IEC_LANGUAGE: ST
*)
BIT_TOGGLE_W := SHL(WORD#1, POS) XOR IN;



(* revision history
hm	18. oct. 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
