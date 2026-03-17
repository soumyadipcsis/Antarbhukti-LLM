(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0	4 feb 2008
programmer 	hugo
tested by	tobias

This function swaps the high and low byte of the word in.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SWAP_BYTE:WORD

(*Group:Default*)


VAR_INPUT
	IN :	WORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: SWAP_BYTE
IEC_LANGUAGE: ST
*)
Swap_Byte := ROL_WORD(in,8);

(* revision history
hm		4. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
