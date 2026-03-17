(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21. jul. 2008
programmer 	hugo
tested by	oscat

Q of tMIN will follow IN except that it forces a minimum ontime for the output Q.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TMIN

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	PT :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	pm :	TP;
END_VAR


(*@KEY@: WORKSHEET
NAME: TMIN
IEC_LANGUAGE: ST
*)
pm(in := IN, PT := PT);
Q := IN OR pm.Q;

(* revision history
hm	21. jul. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
