(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: BUFFER_MANAGMENT
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _BUFFER_UPPERCASE

(*Group:Default*)


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_BUFFER_UPPERCASE :	BOOL;
END_VAR


VAR_IN_OUT
	PT :	oscat_arb_0_249;
END_VAR


VAR
	pos :	INT;
	size2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _BUFFER_UPPERCASE
IEC_LANGUAGE: ST
*)
pos := 0;
size2 := UINT_TO_INT(SIZE);

WHILE pos < size2 DO
	PT[pos] := TO_UPPER(PT[pos]);
	pos := pos + 1;
END_WHILE;

_BUFFER_UPPERCASE := TRUE;

(* revision History
hm 	20. jan. 2011	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
