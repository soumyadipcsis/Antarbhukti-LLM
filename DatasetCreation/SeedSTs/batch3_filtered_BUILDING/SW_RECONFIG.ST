(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	22. oct. 2008
programmer 	hugo
tested by	oscat

SW_reconfig detects if an input is high or low active and debounces the input
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SW_RECONFIG

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	TD :	TIME;
	TR :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	T1 :	TON;
	T2 :	TON;
	INV :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SW_RECONFIG
IEC_LANGUAGE: ST
*)
(* run debounce circuit *)
t1(in := IN, PT := TD);

IF tr > t#0s THEN
	(* generate output *)
	Q := t1.Q XOR inv;
	(* reconfiguration timer *)
	T2(in := Q, pt := TR);
	(* when T2.Q goes high then reverse INV *)
	IF T2.Q THEN INV := NOT INV; END_IF;
ELSE
	Q := t1.Q;
END_IF;



(* revision history
hm	22.10.2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
