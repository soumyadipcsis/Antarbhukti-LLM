(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1		19. oct. 2008
programmer 		hugo
tested by		hugo

CHARCODE converts a HTML Character NAME INTO ITS code
'äuml' is convterted to ä
'euro' is converted to €
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CHARCODE

(*Group:IN_OUT*)


VAR_INPUT
	STR :	oscat_STRING10;
END_VAR


VAR_OUTPUT
	CHARCODE :	BYTE;
END_VAR


VAR
	found :	oscat_STRING1;
	search :	oscat_STRING10;
	pos :	INT;
	CODE :	CODE;
	i :	INT;
	SETUP_CHARNAMES :	SETUP_CHARNAMES;
	CHARNAMES :	oscat_CHARNAMES;
END_VAR


(*@KEY@: WORKSHEET
NAME: CHARCODE
IEC_LANGUAGE: ST
*)
SETUP_CHARNAMES(CHARNAMES:=CHARNAMES);
CHARNAMES:=SETUP_CHARNAMES.CHARNAMES;

IF LEN(str) = 1 THEN
    CODE(STR:=STR,POS:=1);
    CHARCODE:=CODE.CODE;
ELSIF LEN(str) > 0 THEN
	(* construct search string *)
	search := CONCAT('&', str);
	search := CONCAT(search, ';');
	WHILE pos = 0 AND (i < 11) DO
		i := i + 1;
		pos := FIND(CHARNAMES[i], search);
	END_WHILE;
	found := MID(CHARNAMES[i], 1, pos - 1);
    CODE(STR:=found,POS:=1);
    CHARCODE:=CODE.CODE;
END_IF;

(* revision history
hm	13. may. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changed setup constants

hm	24. oct. 2008	rev 1.2
	optimized code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
