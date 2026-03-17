(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: BUFFER_MANAGMENT
*)
(*@KEY@:DESCRIPTION*)
version 1.4	2. jan. 2012
programmer 	hugo
tested by	oscat

this function will copy a string into an array of byte starting at position pos.
this function will manipulate the array directly in memory and returns the position after the input string when finished.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _STRING_TO_BUFFER

(*Group:Default*)


VAR_INPUT
	STR :	oscat_STRING250;
	POS :	INT;
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_STRING_TO_BUFFER :	INT;
END_VAR


VAR_IN_OUT
	PT :	oscat_arb_0_249;
END_VAR


VAR
	i :	INT;
	end :	INT;
	x :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _STRING_TO_BUFFER
IEC_LANGUAGE: ST
*)
IF pos < 0 THEN RETURN; END_IF;
end := MIN(pos + LEN(str), UINT_TO_INT(size)) - 1;
x:= 1;
FOR i := pos TO end DO
	pt[i] := INT_TO_BYTE(GET_CHAR(str,x));
    x := x + 1;
END_FOR;

_STRING_TO_BUFFER := i;

(* revision History

hm 	5. mar. 2008	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint

hm	13. may. 2008	rev 1.2
	changed type of pointer to array[1..32767]
	changed size of string to STRING_LENGTH

hm	12. nov. 2009	rev 1.3
	limit end to size - 1

hm	2. jan 2012	rev 1.4
	return the position after the input string when finished
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
