(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	6. mar 2008
programmer 	oscat
tested by	hugo

ISC_ALPHA checks if a character is a control character.
(*@KEY@:END_DESCRIPTION*)
FUNCTION ISC_CTRL:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: ISC_CTRL
IEC_LANGUAGE: ST
*)
ISC_CTRL := IN < BYTE#32 OR IN = BYTE#127;

(* revision history
hm		6. mar. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
