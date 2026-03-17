(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	25. oct. 2008
programmer 	hugo
tested by	oscat

FSTRING_TO_WEEKDAY converts a weekday string into an integer 1..7.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FSTRING_TO_WEEKDAY

(*Group:Default*)


VAR_INPUT
	WDAY :	oscat_STRING20;
	LANG :	INT;
END_VAR


VAR_OUTPUT
	FSTRING_TO_WEEKDAY :	INT;
END_VAR


VAR
	tmp :	oscat_STRING2;
	i :	INT;
	ly :	INT;
	TRIM :	TRIM;
	SETUP_LANGUAGE :	SETUP_LANGUAGE;
	LANGUAGE :	oscat_LANGUAGE;
	SETUP_WEEKDAYS2 :	SETUP_WEEKDAYS2;
	WEEKDAYS2 :	oscat_WEEKDAYS2;
	LOWERCASE :	LOWERCASE;
	CAPITALIZE :	CAPITALIZE;
	DEC_TO_INT :	DEC_TO_INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FSTRING_TO_WEEKDAY
IEC_LANGUAGE: ST
*)
SETUP_WEEKDAYS2(WEEKDAYS2:=WEEKDAYS2);
WEEKDAYS2:=SETUP_WEEKDAYS2.WEEKDAYS2;
SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

IF LANG = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(LANG, LANGUAGE.LMAX); END_IF;
(* tmp needs to be calculated first otherwise find can return wrong values *)
TRIM(str:=WDAY);
LOWERCASE(str:=TRIM.trim);
tmp:=LOWERCASE.lowercase;
CAPITALIZE(str:=LOWERCASE.lowercase);
tmp:=CAPITALIZE.CAPITALIZE;
FOR i := 1 TO 7 DO
	IF EQ_STRING(WEEKDAYS2[ly][i],tmp) THEN
		FSTRING_TO_WEEKDAY := i;
		RETURN;
	END_IF;
END_FOR;

DEC_TO_INT(DEC:=WDAY);
FSTRING_TO_WEEKDAY:=DEC_TO_INT.DEC_TO_INT;

(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	18. jul. 2008	rev 1.1
	changed nested call of left(trim()) for compatibility reasons

hm	25. oct. 2008	rev 1.2
	using language constants
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
