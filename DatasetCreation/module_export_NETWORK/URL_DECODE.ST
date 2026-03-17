(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. may. 2010
programmer 		hugo
tested by		hugo

URL_DECODE checks a string if it contains non reserved characters represented by a % followed with the two digit hex code and converts them to their ascii code.
the non reserved characters are : [A..Z], [a..z], [0..9], -_.~
for example the character sequence '%23' will be converted to '#'.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK URL_DECODE

(*Group:Default*)


VAR_INPUT
	IN :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	URL_DECODE :	oscat_STRING250;
END_VAR


VAR
	pos :	INT;
	new :	STRING;
	HEX_TO_DWORD :	HEX_TO_DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: URL_DECODE
IEC_LANGUAGE: ST
*)
URL_DECODE := IN;
pos := FIND(URL_DECODE,'%');
WHILE pos > 0 DO
    HEX_TO_DWORD(Hex:=MID(URL_DECODE,2,pos + 1));
	new := BYTE_TO_STRING(DWORD_TO_BYTE(HEX_TO_DWORD.HEX_TO_DWORD),'%c');
	URL_DECODE := REPLACE(URL_DECODE, new, 3, pos);
	pos := FIND(URL_DECODE,'%');
END_WHILE;

(* revision history
hm	27. apr. 2008	rev 1.0
	original version

hm	17. dec. 2008	rev 1.1
	changes name of function chr to chr_to_string

ks	10. mai. 2008	rev 1.2
	stringlength 250
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
