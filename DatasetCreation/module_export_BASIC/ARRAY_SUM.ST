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

this function will calculate the sum of a given array.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_SUM

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_SUM :	REAL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_SUM
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);

array_sum := pt[1];
FOR i := 2 TO stop DO
	array_sum := array_sum + pt[i];
END_FOR;

(* revision history
hm 	2. oct. 2006	rev 1.0
	function created

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
