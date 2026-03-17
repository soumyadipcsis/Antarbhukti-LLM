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

this function will calculate the spread of a given array.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_SPR

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_SPR :	REAL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	array_max :	REAL;
	array_min :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_SPR
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);

array_min := pt[1];
array_max := pt[1];
FOR i := 2 TO stop DO
	IF pt[i] > array_max THEN array_max := pt[i];
	ELSIF pt[i] < array_min THEN array_min := pt[i];
	END_IF;
END_FOR;
array_spr := array_max - array_min;

(* revision history
hm 	2. oct. 2006	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
