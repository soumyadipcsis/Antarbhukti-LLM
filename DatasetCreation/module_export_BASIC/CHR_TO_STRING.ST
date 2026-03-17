(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	17. dec. 2008
programmer 	hugo
tested by	oscat

CHR creates a character from a byte input and stuffs it in a one character length string.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CHR_TO_STRING

(*Group:x*)


VAR_INPUT
	C :	BYTE;
END_VAR


VAR_OUTPUT
	CHR_TO_STRING :	oscat_STRING1;
END_VAR


(*@KEY@: WORKSHEET
NAME: CHR_TO_STRING
IEC_LANGUAGE: ST
*)
CHR_TO_STRING := BYTE_TO_STRING(C,'%c');

(* revision history
hm	16 jan 2007		rev 1.0
	original version

hm	4. feb. 2008	rev 1.1
	return string would not be terminated properly

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(1)

hm	17. dec. 2008	rev 1.3
	changed name of function from chr to chr_to_string
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
