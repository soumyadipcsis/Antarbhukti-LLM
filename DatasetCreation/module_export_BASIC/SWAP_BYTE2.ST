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

This function reverses the byte order in the dword.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SWAP_BYTE2:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: SWAP_BYTE2
IEC_LANGUAGE: ST
*)
Swap_Byte2 := (ROR_DWORD(in,8) AND DWORD#16#FF00FF00) OR (ROL_DWORD(in,8) AND DWORD#16#00FF00FF);

(* revision history
hm		4. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
