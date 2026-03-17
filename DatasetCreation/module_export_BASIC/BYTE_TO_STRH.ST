(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	29 mar. 2008
programmer 	hugo
tested by	tobias

BYTE_TO_STRINGH converts a Byte to a String of Hexadecimal represented by '0' .. '9' and 'A' .. 'F'.
The lowest order Character will be on the right and the high order Character on the left.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BYTE_TO_STRH

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


VAR_OUTPUT
	BYTE_TO_STRH :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: BYTE_TO_STRH
IEC_LANGUAGE: ST
*)
BYTE_TO_STRH:=BYTE_TO_STRING(IN,'%02X');

(* old code
temp := '';
FOR i := 1 TO 2 DO
	X := _BYTE_TO_INT(in AND BYTE#2#0000_1111);
	IF X <= 9 THEN X := X + 48; ELSE X := X + 55; END_IF;

    CHR(C:=INT_TO_BYTE(X));

    temp2 := temp;  
	temp := CONCAT(CHR.CHR, temp2);
	in := SHR(in,4);
END_FOR;
BYTE_TO_STRH := temp;
*)

(* revision history

hm	9.6.2007		rev 1.0		
	original version 

hm	11.9.2007		rev 1.1		
	changed coding for compatibility with twincat, under twincat concat cannot have a function as argument.	

hm	15 dec 2007		REV 1.2
	changed code for higher performance

hm	29. mar. 2008	rev 1.3
	changed STRING to STRING(2)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
