(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	22. oct. 2008
programmer 	hugo
tested by	oscat

this function converts compass directions to degrees
it will recognize up to 3 letter directions in english and german writing.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DIR_TO_DEG

(*Group:Default*)


VAR_INPUT
	DIR :	oscat_STRING3;
	L :	INT;
END_VAR


VAR_OUTPUT
	DIR_TO_DEG :	INT;
END_VAR


VAR
	ly :	INT;
	i :	INT;
	SETUP_DIRS :	SETUP_DIRS;
	DIRS :	oscat_DIRS;
	SETUP_LANGUAGE :	SETUP_LANGUAGE;
	LANGUAGE :	oscat_LANGUAGE;
END_VAR


(*@KEY@: WORKSHEET
NAME: DIR_TO_DEG
IEC_LANGUAGE: ST
*)
SETUP_DIRS(DIRS:=DIRS);
DIRS:=SETUP_DIRS.DIRS;
SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

IF L = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(L, LANGUAGE.LMAX); END_IF;
FOR i := 0 TO 15 DO
	IF EQ_STRING(DIRS[ly][i],DIR) THEN EXIT; END_IF;
END_FOR;
DIR_TO_DEG := WORD_TO_INT(SHR_WORD(INT_TO_WORD(i * 45 + 1), 1));

(* revision histroy
hm	22. oct. 2008	rev 1.1
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
