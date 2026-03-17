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
tested by		hugo

ISC_HEX checks if a character is 0..9, A..F, a..f.
(*@KEY@:END_DESCRIPTION*)
FUNCTION ISC_HEX:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: ISC_HEX
IEC_LANGUAGE: ST
*)
ISC_HEX := (IN > BYTE#47 AND IN < BYTE#58) OR (IN > BYTE#64 AND IN < BYTE#71) OR (IN > BYTE#96 AND IN < BYTE#103);

(* revision history
hm		6. mar. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
