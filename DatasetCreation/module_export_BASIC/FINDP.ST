(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	29. mar. 2008
programmer 	hugo
tested by	tobias

the function findP searches a string str for the occurence of src beginning at the position pos.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FINDP

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	SRC :	STRING;
	POS :	INT;
END_VAR


VAR_OUTPUT
	FINDP :	INT;
END_VAR


VAR
	i :	INT;
	ls :	INT;
	lx :	INT;
	stp :	INT;
	st_tmp :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: FINDP
IEC_LANGUAGE: ST
*)
ls := LEN(str);
lx := LEN(src);
IF ls < lx OR lx = 0 THEN RETURN; END_IF;
stp := ls - lx + 1;
FOR i := MAX(pos,1) TO stp DO
    st_tmp := MID(str,lx,i);
	IF EQ_STRING(st_tmp,src) THEN
		FINDP := i;
		RETURN;
	END_IF;
END_FOR;
FINDP := 0;

(* revision histroy
hm	4. feb. 2008	rev 1.0
	original release

hm	29. feb 2008	rev 1.1
	ADDED MAX(pos,1) in loop initialization

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
