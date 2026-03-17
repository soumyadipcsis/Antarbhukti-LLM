(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: INTERN
*)
(*@KEY@:DESCRIPTION*)
version 1.5	2. jan. 2012
programmer 	hugo
tested by	oscat

this function will insert a string at a given position in a buffer.
this function will manipulate a given array.
the function manipulates the original array, it returnes the next position after the input string when finished.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _BUFFER_INSERT_NW

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	POS :	INT;
END_VAR


VAR_IN_OUT
	PT :	oscat_NW_BUF_LONG;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_BUFFER_INSERT :	INT;
END_VAR


VAR
	end :	INT;
	lx :	INT;
	i :	INT;
	i2 :	INT;
	_STRING_TO_BUFFER :	_STRING_TO_BUFFER;
END_VAR


(*@KEY@: WORKSHEET
NAME: _BUFFER_INSERT_NW
IEC_LANGUAGE: ST
*)
i := UINT_TO_INT(size) - 1;
pos := LIMIT_INT(0,pos,i);
lx := LEN(str);
end := pos + lx;
(* first move the upper part of the buffer to make space for the string *)
i2 := i - lx;
WHILE i >= end DO					
 pt[i] := pt[i2]; 
 i  := i  - 1;
 i2 := i2 - 1;
END_WHILE;

_STRING_TO_BUFFER(str:=str, pos:=pos, size:=size, pt:=pt);
_BUFFER_INSERT := _STRING_TO_BUFFER._STRING_TO_BUFFER;
pt := _STRING_TO_BUFFER.pt;

(* revision History
hm 	9. mar. 2008	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint

hm	13. may. 2008	rev 1.2
	changed type of pointer to array[1..32767]
	changed size of string to STRING_LENGTH

hm	23. mar. 2009	rev 1.3
	avoid writing to input pos

hm	12. nov. 2009	rev 1.4
	code optimized

hm 2. jan 2012	rev 1.5
	function now returns the next position after the input string

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
