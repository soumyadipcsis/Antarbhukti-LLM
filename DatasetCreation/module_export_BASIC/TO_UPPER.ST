(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	16. jan. 2009
programmer 	hugo
tested by	oscat

to_upper converts a character from lowercase to uppercase
(*@KEY@:END_DESCRIPTION*)
FUNCTION TO_UPPER:BYTE

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: TO_UPPER
IEC_LANGUAGE: ST
*)
IF in > BYTE#96 AND in < BYTE#123 THEN
   TO_UPPER := in AND BYTE#16#DF;
ELSIF in > BYTE#223 AND in <> BYTE#247 AND in <> BYTE#255 AND SETUP_EXTENDED_ASCII(FALSE) THEN
   TO_UPPER := in AND BYTE#16#DF;
ELSE
   TO_UPPER := in;
END_IF;

(* revision history
hm	6. mar. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changed setup constants

ks	25. oct. 2008	rev 1.2
	optimized code

hm 16. jan 2009	rev 1.3
	corrected an error in module

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
