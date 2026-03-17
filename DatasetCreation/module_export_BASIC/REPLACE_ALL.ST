(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. mar. 2008
programmer 	hugo
tested by	tobias

the function findP searches a string str for the occurence of src beginning at the position pos.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REPLACE_ALL

(*Group:Default*)


VAR_INPUT
	STR :	oscat_STRING250;
	SRC :	STRING;
	REP :	STRING;
END_VAR


VAR_OUTPUT
	REPLACE_ALL :	STRING;
END_VAR


VAR
	pos :	INT;
	lp :	INT;
	lx :	INT;
	FINDP :	FINDP;
	st_tmp :	oscat_STRING250;
END_VAR


(*@KEY@: WORKSHEET
NAME: REPLACE_ALL
IEC_LANGUAGE: ST
*)
REPLACE_ALL := str;
lx := LEN(src);
lp := LEN(rep);

FINDP.str := REPLACE_ALL;
FINDP.src := src;
FINDP.pos := 1;
FINDP();
pos := FINDP.FINDP;

WHILE pos > 0 DO
    st_tmp := REPLACE_ALL;
	REPLACE_ALL := REPLACE(st_tmp,rep,lx,pos);

    FINDP.str := REPLACE_ALL;
    FINDP.src := src;
    FINDP.pos := pos + lp;
    FINDP();
    pos := FINDP.FINDP;

END_WHILE;

(* revision histroy
hm	4. feb. 2008	rev 1.0
	original release

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
