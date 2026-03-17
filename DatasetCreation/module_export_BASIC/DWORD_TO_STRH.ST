(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	29. mar. 2008
programmer 	hugo
tested by	tobias

DWORD_TO_STRINGH converts a DWORD to a String of Hexadecimal represented by '0' .. '9' and 'A' .. 'F'.
The lowest order Character will be on the right and the high order Character on the left.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DWORD_TO_STRH

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
END_VAR


VAR_OUTPUT
	DWORD_TO_STRH :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: DWORD_TO_STRH
IEC_LANGUAGE: ST
*)
DWORD_TO_STRH:=DWORD_TO_STRING(IN,'%08X');

(* old code 
temp :='';
FOR i := 1 TO 8 DO
	X := DWORD_TO_INT(in AND DWORD#2#1111);
	IF X <= 9 THEN X := X + 48; ELSE X := X + 55; END_IF;

    CHR(C:=INT_TO_BYTE(X));

    temp2 := temp;
	temp := CONCAT(CHR.CHR, temp2);
	in := SHR(in,4);
END_FOR;
DWORD_TO_STRH := temp;
*)

(* revision history
hm	9. jun. 2007	rev 1.0		
	original version 

hm	11. sep. 2007	rev 1.1
	changed coding for compatibility with twincat, concat cannot support a function as an argument.

hm	15. dec. 2007	rev 1.2
	changed code for better performance

hm	29. mar. 2008	rev 1.3
	changed STRING to STRING(8)

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
