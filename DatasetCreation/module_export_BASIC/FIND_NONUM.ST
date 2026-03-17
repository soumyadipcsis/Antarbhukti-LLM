(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	21. oct. 2008
programmer 	hugo
tested by	tobias

find_noNum searches str and returns the first position which is not a number.
a number is characterized by a letter "0..9" or "."
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FIND_NONUM

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	POS :	INT;
END_VAR


VAR_OUTPUT
	FIND_NONUM :	INT;
END_VAR


VAR
	X :	INT;
	end :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIND_NONUM
IEC_LANGUAGE: ST
*)
end := LEN(str);
FOR pos := MAX(pos,1) TO LEN(str) DO;
     X :=GET_CHAR(str,pos);
	IF (X < 48 AND X <> 46) OR X > 57 THEN
		find_nonum := pos;
		RETURN;
	END_IF;
END_FOR;
find_nonum := 0;

(* revision history
hm	6. oct. 2006	rev 1.0
	original version

hm	29. feb 2008	rev 1.1
	added input pos to start search at position

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)

hm	21. oct. 2008	rev 1.3
	optimized code

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
