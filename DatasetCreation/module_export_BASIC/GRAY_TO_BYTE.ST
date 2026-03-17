(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0	9. nov. 2009
programmer 	hugo
tested by	oscat

this function converts a gray code into binary

(*@KEY@:END_DESCRIPTION*)
FUNCTION GRAY_TO_BYTE:BYTE

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: GRAY_TO_BYTE
IEC_LANGUAGE: ST
*)
GRAY_TO_BYTE := SHR_BYTE(IN,4) XOR IN;
GRAY_TO_BYTE := SHR_BYTE(GRAY_TO_BYTE,2) XOR GRAY_TO_BYTE;
GRAY_TO_BYTE := SHR_BYTE(GRAY_TO_BYTE,1) XOR GRAY_TO_BYTE;

(* revision history
hm	9. nov. 2009	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
