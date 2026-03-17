(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	19. oct. 2008
programmer 	hugo
tested by	oscat

isc_lower checks if a character is lowercase.
(*@KEY@:END_DESCRIPTION*)
FUNCTION ISC_LOWER:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: ISC_LOWER
IEC_LANGUAGE: ST
*)
IF SETUP_EXTENDED_ASCII(FALSE) THEN
	ISC_LOWER := ((in > BYTE#96) AND (in < BYTE#123)) OR ((in > BYTE#222) AND (in <> BYTE#247));
ELSE
	ISC_LOWER := ((in > BYTE#96) AND (in < BYTE#123));
END_IF;

(* revision history
hm	6. mar. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changes setup constants
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
