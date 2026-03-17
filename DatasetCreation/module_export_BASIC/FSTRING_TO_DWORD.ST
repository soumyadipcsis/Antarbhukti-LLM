(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. sep. 2008
programmer 	hugo
tested by		oscat

FSTRING_TO_BYTE converts a formatted string into a byte.
the string can be of the form 2#01010, 8#7234, 16#2AD3 and 1234
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FSTRING_TO_DWORD

(*Group:Default*)


VAR_INPUT
	IN :	oscat_STRING40;
END_VAR


VAR_OUTPUT
	FSTRING_TO_DWORD :	DWORD;
END_VAR


VAR
	CLEAN :	CLEAN;
	BIN_TO_DWORD :	BIN_TO_DWORD;
	OCT_TO_DWORD :	OCT_TO_DWORD;
	HEX_TO_DWORD :	HEX_TO_DWORD;
	tmp :	oscat_STRING3;
END_VAR


(*@KEY@: WORKSHEET
NAME: FSTRING_TO_DWORD
IEC_LANGUAGE: ST
*)
tmp := LEFT(IN, 2);
IF EQ_STRING(tmp,'2#') THEN
	(* we need to convert binary *)
    BIN_TO_DWORD(BIN:=RIGHT(in, LEN(in) - 2));
	FSTRING_TO_DWORD := BIN_TO_DWORD.BIN_TO_DWORD;
ELSIF EQ_STRING(tmp,'8#') THEN
	(* weneed to convert octals *)
    OCT_TO_DWORD(OCT:=RIGHT(in, LEN(in) - 2));
	FSTRING_TO_DWORD := OCT_TO_DWORD.OCT_TO_DWORD;
ELSE
    tmp := LEFT(IN, 3);
    IF EQ_STRING(tmp,'16#') THEN
	    (* we need to convert hexadecimal *)
        HEX_TO_DWORD(HEX:=RIGHT(in, LEN(in) - 3));
	    FSTRING_TO_DWORD := HEX_TO_DWORD.HEX_TO_DWORD;
    ELSE
	    (* we assume decimal representation *)
        CLEAN(IN:=in,CX:='0123456789');
	    FSTRING_TO_DWORD := STRING_TO_DWORD(CLEAN.CLEAN);
    END_IF;
END_IF;

(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	20. sep. 2008	rev 1.1
	changed length of input dtring from 20 to 40


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
