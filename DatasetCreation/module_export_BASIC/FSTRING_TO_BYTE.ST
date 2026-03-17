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
FUNCTION_BLOCK FSTRING_TO_BYTE

(*Group:Default*)


VAR_INPUT
	IN :	oscat_STRING12;
END_VAR


VAR_OUTPUT
	FSTRING_TO_BYTE :	BYTE;
END_VAR


VAR
	CLEAN :	CLEAN;
	BIN_TO_BYTE :	BIN_TO_BYTE;
	OCT_TO_BYTE :	OCT_TO_BYTE;
	HEX_TO_BYTE :	HEX_TO_BYTE;
	tmp :	oscat_STRING3;
END_VAR


(*@KEY@: WORKSHEET
NAME: FSTRING_TO_BYTE
IEC_LANGUAGE: ST
*)
IF LEN(IN)=0 THEN FSTRING_TO_BYTE := BYTE#0;RETURN;END_IF;

tmp := LEFT(IN,MIN(2,LEN(IN)));
IF EQ_STRING(tmp,'2#') THEN
	(* we need to convert binary *)
    BIN_TO_BYTE(BIN:=RIGHT(in, LEN(in) - 2));
	FSTRING_TO_BYTE := BIN_TO_BYTE.BIN_TO_BYTE;
ELSIF EQ_STRING(tmp,'8#') THEN
	(* weneed to convert octals *)
    OCT_TO_BYTE(OCT:=RIGHT(in, LEN(in) - 2));
	FSTRING_TO_BYTE := OCT_TO_BYTE.OCT_TO_BYTE;
ELSE
    tmp := LEFT(IN,MIN(3,LEN(IN)));
    IF EQ_STRING(tmp,'16#') THEN
	    (* we need to convert hexadecimal *)
        HEX_TO_BYTE(HEX:=RIGHT(in, LEN(in) - 3));
	    FSTRING_TO_BYTE := HEX_TO_BYTE.HEX_TO_BYTE;
    ELSE
	    (* we assume decimal representation *)
        CLEAN(IN:=in,CX:='0123456789');
	    FSTRING_TO_BYTE := STRING_TO_BYTE(CLEAN.CLEAN);
    END_IF;
END_IF;

(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	20. sep. 2008	rev 1.1
	changed length of input string from 20 to 12
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
