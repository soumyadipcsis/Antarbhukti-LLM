(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	25. oct 2008
programmer 	hugo
tested by	tobias

to_lower converts a character from uppercase to lowercase
(*@KEY@:END_DESCRIPTION*)
FUNCTION TO_LOWER:BYTE

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: TO_LOWER
IEC_LANGUAGE: ST
*)
IF in > BYTE#64 AND in < BYTE#91 THEN
   TO_LOWER := in OR BYTE#16#20;
ELSIF (in > BYTE#191 AND in < BYTE#223) AND in <> BYTE#215 AND SETUP_EXTENDED_ASCII(FALSE) THEN
   TO_LOWER := in OR BYTE#16#20;
ELSE
   TO_LOWER := in;
END_IF;

(* revision history
hm	6. mar. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changed setup constants

ks	25. oct. 2008	rev 1.2
	optimized code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
