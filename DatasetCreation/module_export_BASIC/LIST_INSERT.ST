(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LIST_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 2.0	21. mar. 2011
programmer 	hugo
tested by	oscat

LIST_INSERT setzt ein element an der stelle pos in eine liste ein.
die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_INSERT

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
	POS :	INT;
	INS :	oscat_STRING250;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_INSERT :	BOOL;
END_VAR


VAR
	cnt :	INT;
	tmp :	oscat_STRING250;
	CHR_TO_STRING :	CHR_TO_STRING;
	size :	INT;
	read :	INT;
	_INSERT :	_INSERT250;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_INSERT
IEC_LANGUAGE: ST
*)
CHR_TO_STRING(C:=SEP);
read := 1;
cnt := 1;
size := LEN(LIST);
POS := MAX(POS,1);
LIST_INSERT := FALSE;

WHILE read < 250 DO
	IF cnt = POS THEN
        tmp := CONCAT(CHR_TO_STRING.CHR_TO_STRING, INS);
        _INSERT(IN1:=LIST,IN2:=tmp,P:=read - 1);
        LIST :=_INSERT._INSERT;
		LIST_INSERT := TRUE;
		RETURN;
	END_IF;
	IF read > size THEN
        LIST := CONCAT(LIST,CHR_TO_STRING.CHR_TO_STRING);
        size := size + 1;
    END_IF; 
    read := read + 1;
    IF read > size THEN
	    cnt := cnt + 1;
    ELSIF INT_TO_BYTE(GET_CHAR(LIST,read)) = SEP THEN
	    cnt := cnt + 1;
    END_IF; 
END_WHILE;

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
