(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	19. oct. 2008
programmer 	hugo
tested by	oscat

MONTH_TO_STRING converts an Integer 1..12 into a String with the Names of the corresponding Month.
the decoding is according to the language setup in global vars
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MONTH_TO_STRING

(*Group:Default*)


VAR_INPUT
	MTH :	INT;
	LANG :	INT;
	LX :	INT;
END_VAR


VAR_OUTPUT
	MONTH_TO_STRING :	oscat_STRING10;
END_VAR


VAR
	LY :	INT;
	SETUP_MONTHS :	SETUP_MONTHS;
	MONTHS :	oscat_MONTHS;
	SETUP_MONTHS3 :	SETUP_MONTHS3;
	MONTHS3 :	oscat_MONTHS3;
	SETUP_LANGUAGE :	SETUP_LANGUAGE;
	LANGUAGE :	oscat_LANGUAGE;
END_VAR


(*@KEY@: WORKSHEET
NAME: MONTH_TO_STRING
IEC_LANGUAGE: ST
*)
SETUP_MONTHS(MONTHS:=MONTHS);
MONTHS:=SETUP_MONTHS.MONTHS;
SETUP_MONTHS3(MONTHS3:=MONTHS3);
MONTHS3:=SETUP_MONTHS3.MONTHS3;
SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

IF LANG = 0 THEN Ly := LANGUAGE.DEFAULT; ELSE ly := MIN(LANG, language.LMAX); END_IF;
IF MTH < 1 OR MTH > 12 THEN
	RETURN;
ELSIF LX = 0 THEN
	MONTH_TO_STRING := MONTHS[ly][MTH];
ELSIF Lx = 3 THEN
	MONTH_TO_STRING := MONTHS3[ly][MTH];
END_IF;

(* revisison history

hm	21. sep. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changed language setup constants
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
