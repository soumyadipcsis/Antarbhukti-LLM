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

this function converts degrees in compass direction.
the function supports output in english (L=0) and german (L=1)
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DEG_TO_DIR

(*Group:Default*)


VAR_INPUT
	DEG :	INT;
	N :	INT;
	L :	INT;
END_VAR


VAR_OUTPUT
	DEG_TO_DIR :	oscat_STRING3;
END_VAR


VAR
	ly :	INT;
	y :	INT;
	SETUP_DIRS :	SETUP_DIRS;
	DIRS :	oscat_DIRS;
	SETUP_LANGUAGE :	SETUP_LANGUAGE;
	LANGUAGE :	oscat_LANGUAGE;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEG_TO_DIR
IEC_LANGUAGE: ST
*)
SETUP_DIRS(DIRS:=DIRS);
DIRS:=SETUP_DIRS.DIRS;
SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

IF L = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(L, LANGUAGE.LMAX); END_IF;
y := ((WORD_TO_INT(SHL(INT_TO_WORD(DEG),N-1)) + 45) / 90) MOD WORD_TO_INT(SHL(WORD#2,N))* WORD_TO_INT(SHR(WORD#8,N)); 
DEG_TO_DIR := DIRS[ly][y];


(*
DIR := ((SHL(DEG,N-1) + 45) / 90) MOD SHL(INT#2,N);
explanation :
DIR is calculated BY the following formula:
DIR := ((DIR + 45) / 90) MOD 4 if N = 1 digit
North = 0, East = 1 ....
DIR := ((DIR + 22,5) / 45) MOD 8 if N = 2 digit
convert to integer calculation
DIR := ((DIR*2 + 45) / 90) MOD 8
N = 0, NE = 1 ....
ther above formula replaces 2^N with shift for performance
*)



(* revision histroy
hm	11. jun. 2008	rev 1.0
	original release

hm	22. oct. 2008	rev 1.1
	changed size of string variables to 30
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
