(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	hugo
tested by	tobias

this function will calculate the average of a given array.
the function needs to be called:	array_avg(adr("array"),sizeof("array"));
because this function works with pointers its very time efficient and it needs no extra memory.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_AVG

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_AVG :	REAL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_AVG
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);

array_avg := 0.0;
FOR i := 1 TO stop DO
	array_avg := array_avg + pt[i];
END_FOR;
array_avg := array_avg / INT_TO_REAL(stop);

(* revision history
hm	2. oct 2007		rev 1.0
	original version

hm	12. dec 2007	rev 1.1
	chaged code for better performance

hm	16. mar. 2008	rev 1.2
	changed input size to uint
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
