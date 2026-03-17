(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.4		17. dec. 2008
programmer 		hugo
tested by		oscat

CHARNAME converts a Character code into its HTML character name
ä is convterted to 'äuml'
€ is converted to 'euro'
the character itself is returned if no name is available for the character
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CHARNAME

(*Group:IN_OUT*)


VAR_INPUT
	C :	BYTE;
END_VAR


VAR_OUTPUT
	CHARNAME :	oscat_STRING10;
END_VAR


VAR
	CHARNAME2 :	oscat_STRING10;
	pos :	INT;
	i :	INT;
	CHR_TO_STRING :	CHR_TO_STRING;
	SETUP_CHARNAMES :	SETUP_CHARNAMES;
	CHARNAMES :	oscat_CHARNAMES;
END_VAR


(*@KEY@: WORKSHEET
NAME: CHARNAME
IEC_LANGUAGE: ST
*)
SETUP_CHARNAMES(CHARNAMES:=CHARNAMES);
CHARNAMES:=SETUP_CHARNAMES.CHARNAMES;

IF C <> BYTE#0 THEN
	(* construct search string from code followed by $ sign, also clear charname string*)
	CHR_TO_STRING(C:=C);
	CHARNAME := CHR_TO_STRING.CHR_TO_STRING;
	CHARNAME2 := CONCAT(CHARNAME,'&');
	CHARNAME := CONCAT(';', CHARNAME2);
	WHILE pos = 0 AND (i < 11) DO
		i := i + 1;
		pos := FIND(CHARNAMES[i], CHARNAME);
	END_WHILE;
	IF pos > 0 THEN
		CHARNAME := MID(CHARNAMES[i], 10, pos + 3);
		(* search for end of name and truncate *)
		pos := FIND(CHARNAME, ';');
		CHARNAME := LEFT(CHARNAME,pos - 1);
	ELSE
		CHR_TO_STRING(C:=C);
		CHARNAME := CHR_TO_STRING.CHR_TO_STRING;
	END_IF;
ELSE
	CHARNAME := '';
END_IF;


(* revision history
hm	13. may. 2008	rev 1.0
	original version

hm	16. jun. 2008	rev 1.1
	changed nested call of concat for better compatibility

hm	19. oct. 2008	rev 1.2
	changes setup constants

hm	24. oct. 2008	rev 1.3
	new code for high performance

hm	17. dec. 2008	rev 1.4
	changed function chr to chr_to_string
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
