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

ISC_NUM checks if a character is 0..9.
(*@KEY@:END_DESCRIPTION*)
FUNCTION ISC_NUM:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: ISC_NUM
IEC_LANGUAGE: ST
*)
ISC_NUM := IN > BYTE#47 AND IN < BYTE#58;

(* revision history
hm		6. mar. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
