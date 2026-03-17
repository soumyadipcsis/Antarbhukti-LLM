(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16. mar 2008
programmer 	hugo
tested by	tobias

this function will calculate the standard deviation of a given array.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_SDV

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_SDV :	REAL;
END_VAR


VAR
	FB_array_var :	array_var;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_SDV
IEC_LANGUAGE: ST
*)
(* standard deviation is simply the square root of the variance *)

FB_array_var.pt   := pt;
FB_array_var.size := size;
FB_array_var();
pt := FB_array_var.pt;

array_sdv := SQRT(FB_array_var.array_var);

(* revision history
hm 	1.4.2007		rev 1.0
	function created

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
