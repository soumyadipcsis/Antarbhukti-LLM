(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	3 Jan 2007
programmer 	hugo
tested by	tobias

FT_IMP is 	an impulse filter (high pass filter) with the time T and factor K.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_IMP

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	T :	TIME;
	K :	REAL := 1.0;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
END_VAR


VAR
	t1 :	FT_PT1;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_IMP
IEC_LANGUAGE: ST
*)
T1(in:= in, T:=T);
out := (in - t1.out) * K;

(*
hm 3.1.2007	rev 1.1
	added factor K

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
