(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	26 jan 2007
programmer 	hugo
tested by		tobias

dword_to_strF converts a DWORD, BYTE or Word to a fixed length String.
the string will be filled with leading zeroes to achieve the fixed length, or if too long, the lowest digits will be used.
the maximum allowed length is 20 mdigits.

for example:	dword_to_strf(123,4) = '0123' 
				dword_to_strf(123,2) = '23'
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DWORD_TO_STRF

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	N :	INT;
END_VAR


VAR_OUTPUT
	DWORD_TO_STRF :	STRING;
END_VAR


VAR
	FIX :	FIX;
END_VAR


(*@KEY@: WORKSHEET
NAME: DWORD_TO_STRF
IEC_LANGUAGE: ST
*)
(* limit N to max 20 characters *)
(* convert dword to string first and cut to length N *)
FIX(str:=DWORD_TO_STRING(in,'%u'),L:=LIMIT(0,N,20),C:=BYTE#48,M:=1);
DWORD_TO_STRF:=FIX.FIX;

(* old code  

temp := DWORD_TO_STRING(in,STRING#'%u');
L := LEN(temp);
IF N < L THEN
    temp :=RIGHT(temp,N);
    L := N;
END_IF;

WHILE L < N DO
    temp2 := temp;
	temp := CONCAT('0', temp2);
	L := L + 1;
END_WHILE;
DWORD_TO_STRF := temp;

*)

(* revision history
hm	26. jan.2007	rev 1.0		
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(20)
	limit the output string to max 20 digits
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
