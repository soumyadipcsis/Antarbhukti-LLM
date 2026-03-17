(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	25. oct 2008
programmer 	hugo
tested by	oscat

FSTRING_TO_MONTH converts a string into a month, the string can be a name for the month or a number.
the function is language sensitve when LANG > 1 and checks for all languages when LANG = 0
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FSTRING_TO_MONTH

(*Group:Default*)


VAR_INPUT
	MTH :	oscat_STRING20;
	LANG :	INT;
END_VAR


VAR_OUTPUT
	FSTRING_TO_MONTH :	INT;
END_VAR


VAR
	lx :	INT;
	SETUP_MONTHS :	SETUP_MONTHS;
	MONTHS :	oscat_MONTHS;
	SETUP_MONTHS3 :	SETUP_MONTHS3;
	MONTHS3 :	oscat_MONTHS3;
	SETUP_LANGUAGE :	SETUP_LANGUAGE;
	LANGUAGE :	oscat_LANGUAGE;
	LOWERCASE :	LOWERCASE;
	CAPITALIZE :	CAPITALIZE;
	IS_NUM :	IS_NUM;
END_VAR


(*@KEY@: WORKSHEET
NAME: FSTRING_TO_MONTH
IEC_LANGUAGE: ST
*)
SETUP_MONTHS(MONTHS:=MONTHS);
MONTHS:=SETUP_MONTHS.MONTHS;
SETUP_MONTHS3(MONTHS3:=MONTHS3);
MONTHS3:=SETUP_MONTHS3.MONTHS3;
SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

IF LANG = 0 THEN lx := LANGUAGE.DEFAULT; ELSE lx := MIN(LANG, LANGUAGE.LMAX); END_IF;
LOWERCASE(str:=MTH);
CAPITALIZE(str:=LOWERCASE.lowercase);
MTH:=CAPITALIZE.CAPITALIZE;

FOR FSTRING_TO_MONTH := 1 TO 12 DO
	IF EQ_STRING(MTH,MONTHS[lx][FSTRING_TO_MONTH]) THEN RETURN; END_IF;
	IF EQ_STRING(MTH,MONTHS3[lx][FSTRING_TO_MONTH]) THEN RETURN; END_IF;
END_FOR;

(* since no name matched try to decode as integer *)
IS_NUM(str:=MTH);
IF IS_NUM.IS_NUM THEN
	FSTRING_TO_MONTH := STRING_TO_INT(MTH);
ELSE
	FSTRING_TO_MONTH := 0;
END_IF;

(* revision histroy
hm	25. sep. 2008	rev 1.0
	original release

hm	19. oct. 2008	rev 1.1
	changed language setup constants

hm	25. oct. 2008	rev 1.2
	optimized code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
