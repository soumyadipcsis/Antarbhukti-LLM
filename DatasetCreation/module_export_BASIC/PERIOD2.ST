(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	27. apr. 2008
programmer 	hugo
tested by	tobias

PERIOD2 checks if DX is within one of 4 periods and sets the output true if so.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PERIOD2

(*Group:Default*)


VAR_INPUT
	DP :	oscat_PERIOD2_X;
	DX :	UDINT;
END_VAR


VAR_OUTPUT
	PERIOD2 :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: PERIOD2
IEC_LANGUAGE: ST
*)
PERIOD2 := 	(DX >= DP[0][0] AND DX <= DP[0][1]) OR
			(DX >= DP[1][0] AND DX <= DP[1][1]) OR
			(DX >= DP[2][0] AND DX <= DP[2][1]) OR
			(DX >= DP[3][0] AND DX <= DP[3][1]);


(* revision history

hm		27. apr 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
