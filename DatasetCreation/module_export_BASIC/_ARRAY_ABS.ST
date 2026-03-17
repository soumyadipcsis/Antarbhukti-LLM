(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	2. apr. 2008
programmer 	hugo
tested by	tobias

this function will calculate the absolute value of each element of the array and stroe the result instead of the element.
Array[i] := ABS(ARRAY[i]).
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _ARRAY_ABS

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_ARRAY_ABS :	BOOL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _ARRAY_ABS
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
FOR i := 1 TO stop DO
	 pt[i] := ABS(pt[i]);
END_FOR;
_ARRAY_ABS := TRUE;

(* revision history
hm	2. apr 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
