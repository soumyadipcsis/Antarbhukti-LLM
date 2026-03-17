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

this function converts a binary to gray code
(*@KEY@:END_DESCRIPTION*)
FUNCTION BYTE_TO_GRAY:BYTE

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: BYTE_TO_GRAY
IEC_LANGUAGE: ST
*)
BYTE_TO_GRAY := IN XOR SHR(IN,1);

(* revision history
hm	9. nov. 2009	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
