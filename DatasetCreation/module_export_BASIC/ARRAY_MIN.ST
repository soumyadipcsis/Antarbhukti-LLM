(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16. mar. 2008
programmer 	hugo
tested by	tobias

this function will calculate the min value of a given array.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_MIN

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_MIN :	REAL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_MIN
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);

array_min := pt[1];
FOR i := 2 TO stop DO
	IF pt[i] < array_min THEN array_min := pt[i]; END_IF;
END_FOR;

(* revision history
hm		2. oct. 2006
	original version

hm		16. mar. 2008
	changed type of input size to uint

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
