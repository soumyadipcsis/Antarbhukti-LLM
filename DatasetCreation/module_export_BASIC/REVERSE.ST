(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. feb 2008
programmer 	hugo
tested BY	tobias

This function reverses the bits of a byte so that after execution bit 7 is at bit 0 location and so forth.
(*@KEY@:END_DESCRIPTION*)
FUNCTION REVERSE:BYTE

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: REVERSE
IEC_LANGUAGE: ST
*)
reverse := SHL_BYTE(in,7) OR SHR_BYTE(in,7) OR (ROR_BYTE(in,3) AND BYTE#2#01000100) OR (ROL_BYTE(in,3) AND BYTE#2#00100010)
	OR (SHL_BYTE(in,1) AND BYTE#2#00010000) OR (SHR_BYTE(in,1) AND BYTE#2#00001000);

(* revision history
hm		9.oct 2007		rev 1.0
	original version

hm		18. feb 2008	rev 1.1
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
