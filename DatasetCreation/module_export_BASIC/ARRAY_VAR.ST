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
tested by		tobias

this function will calculate the variance of a given array.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_VAR

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_VAR :	REAL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	avg :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_VAR
IEC_LANGUAGE: ST
*)
(* at first we calualte the arithmetic average of the array *)

stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
avg := pt[1];
FOR i := 2 TO stop DO
	avg := avg + pt[i];
END_FOR;
avg := avg / INT_TO_REAL(stop);

(* in a second run we calculate the variance of the array *)

array_var := EXPT(pt[1] - avg, 2.0);
FOR i := 2 TO stop DO
	array_var := array_var + EXPT(pt[i] - avg, 2.0);
END_FOR;
array_var := array_var / INT_TO_REAL(stop-1);

(* revision history
hm 	1.4.2007	rev 1.0
	function created

hm	12.12.2007	rev 1.1
	changed code for better performance

hm	16. mar. 2008	rev 1.2
	changed type of input size to uint

hm	10. mar. 2009	rev 1.3
	added type conversions for compatibility reasons
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
