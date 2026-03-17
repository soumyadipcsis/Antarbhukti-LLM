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

ISC_upper checks if a character is uppercase
(*@KEY@:END_DESCRIPTION*)
FUNCTION ISC_UPPER:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: ISC_UPPER
IEC_LANGUAGE: ST
*)
IF SETUP_EXTENDED_ASCII(FALSE) THEN
	ISC_UPPER :=  ((in > BYTE#64) AND (in < BYTE#91)) OR (((in > BYTE#191) AND (in < BYTE#223)) AND (in <> BYTE#215));
ELSE
	ISC_UPPER := ((in > BYTE#64) AND (in < BYTE#91));
END_IF;

(* revision history
hm	6. mar. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changes setup constants

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
