(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	25. oct. 2008
programmer 	hugo
tested by	oscat

FSTRING_TO_WEEK converts a list of weekdays into a byte where each bit represents a day of the week.
bit 6 = mo, 0 = su;
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FSTRING_TO_WEEK

(*Group:Default*)


VAR_INPUT
	WEEK :	oscat_STRING60;
	LANG :	INT;
END_VAR


VAR_OUTPUT
	FSTRING_TO_WEEK :	BYTE;
END_VAR


VAR
	pos :	INT;
	FSTRING_TO_WEEKDAY :	FSTRING_TO_WEEKDAY;
END_VAR


(*@KEY@: WORKSHEET
NAME: FSTRING_TO_WEEK
IEC_LANGUAGE: ST
*)
pos := FIND(WEEK, ',');
WHILE pos > 0 DO
    FSTRING_TO_WEEKDAY(WDAY:=MID(WEEK, pos - 1, 1),LANG:=LANG);
	FSTRING_TO_WEEK := FSTRING_TO_WEEK OR SHR_BYTE(BYTE#128, FSTRING_TO_WEEKDAY.FSTRING_TO_WEEKDAY);
	WEEK := RIGHT(WEEK, LEN(Week) - pos);
	pos := FIND(WEEK, ',');
END_WHILE;

FSTRING_TO_WEEKDAY(WDAY:=WEEK,LANG:=LANG);
FSTRING_TO_WEEK := (FSTRING_TO_WEEK OR SHR(BYTE#128, FSTRING_TO_WEEKDAY.FSTRING_TO_WEEKDAY)) AND BYTE#127;


(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	25. oct. 2008	rev 1.1
	using language defauls and input lang
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
