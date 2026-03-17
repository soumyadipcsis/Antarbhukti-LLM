(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	20. jun. 2008
programmer 	hugo
tested by	oscat

DWORD_TO_STRINGB converts a DWORD to a String of Bits represented by '0' and '1' s.
The lowest order bit will be on the right and the high order bit on the left.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DWORD_TO_STRB

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
END_VAR


VAR_OUTPUT
	DWORD_TO_STRB :	oscat_STRING32;
END_VAR


VAR
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DWORD_TO_STRB
IEC_LANGUAGE: ST
*)
DWORD_TO_STRB :='';
FOR i := 1 TO 32 DO
    IF (in AND DWORD#16#8000_0000) > DWORD#0 THEN
        DWORD_TO_STRB := CONCAT(DWORD_TO_STRB,'1');
    ELSE
        DWORD_TO_STRB := CONCAT(DWORD_TO_STRB,'0');
    END_IF;
	in := SHL(in, 1);
END_FOR;

(* revision history
hm		9.6.2007	rev 1.0		
	original version

hm		15.dec 2007	rev 1.1
	changed code for better performance

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(32)

hm	20. jun. 2008	rev 1.3
	performance improvement

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
