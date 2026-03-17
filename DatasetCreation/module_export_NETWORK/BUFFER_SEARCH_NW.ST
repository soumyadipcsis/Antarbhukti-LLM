(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: INTERN
*)
(*@KEY@:DESCRIPTION*)
version 1.4	25. jan 2011
programmer 	hugo
tested by	oscat

this function will search for a string STR in an array of byte starting at position pos.
The function returns the position of the first character of the string in the array if found.
a -1 is returned if the string is not found in the array.
when IGN = TRUE, STR must be in capital letters and the search is case insensitv.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BUFFER_SEARCH_NW

(*Group:Default*)


VAR_INPUT
	SIZE :	UINT;
	STR :	oscat_STRING250;
	POS :	INT;
	IGN :	BOOL;
END_VAR


VAR_IN_OUT
	PT :	oscat_NW_BUF_LONG;
END_VAR


VAR_OUTPUT
	BUFFER_SEARCH :	INT;
END_VAR


VAR
	i :	INT;
	end :	INT;
	k :	INT;
	k2 :	INT;
	lx :	INT;
	char :	BYTE;
	chx :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: BUFFER_SEARCH_NW
IEC_LANGUAGE: ST
*)
lx := LEN(str);
IF pos >= 0 AND lx > 0 THEN 
	end := UINT_TO_INT(size) - lx;
	lx := lx - 1;
	FOR i := pos TO end DO
		FOR k := 0 TO lx DO
			char := INT_TO_BYTE(GET_CHAR(str,k + 1));
			k2 := i + k;
			IF IGN THEN
				chx := TO_UPPER(pt[k2]);
			ELSE
				chx := pt[k2];
			END_IF;
			IF char <> chx THEN EXIT; END_IF;
		END_FOR;
		IF k > lx THEN
			BUFFER_SEARCH := i;
			RETURN;
		END_IF;
	END_FOR;
END_IF;
BUFFER_SEARCH := -1;

(* revision History

hm 5. mar. 2008	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	chaged type of input size to uint

hm	13. may. 2008	rev 1.2
	changed type of pointer to array[1..32767]
	changed size of string to STRING_LENGTH

hm	12. nov. 2009	rev 1.3
	limit end to array size

hm	19. jan. 2011	rev 1.4
	return -1 if nothing found

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
