(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	tobias

takahashi calculates controller parameters for P, PI and PID controllers based on the ziegler nichols method.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CONTROL_SET1

(*Group:Default*)


VAR_INPUT
	KT :	REAL;
	TT :	REAL;
	PI :	BOOL;
	PID :	BOOL;
	P_K :	REAL := 0.5;
	PI_K :	REAL := 0.45;
	PI_TN :	REAL := 0.83;
	PID_K :	REAL := 0.6;
	PID_TN :	REAL := 0.5;
	PID_TV :	REAL := 0.125;
END_VAR


VAR_OUTPUT
	KP :	REAL;
	TN :	REAL;
	TV :	REAL;
	KI :	REAL;
	KD :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CONTROL_SET1
IEC_LANGUAGE: ST
*)
IF pi AND PID THEN
	KP := 0.0;
	TN := 0.0;
	TV := 0.0;
ELSIF PID THEN
	KP := PID_K * Kt;
	TN := PID_TN * Tt;
	TV := PID_TV * Tt;
ELSIF PI THEN
	KP := PI_K * Kt;
	TN := PI_TN * Tt;
ELSE
	KP := P_K * Kt;
END_IF;

(* KI and KD are calculated *)
IF tn > 0.0 THEN KI := KP / TN; ELSE KI := 0.0; END_IF;
KD := KP * TV;

(* revision history
hm	4. nov 2007	rev 1.0
	original version

hm	11. mar. 2009	rev 1.1
	real constants updated to new systax using dot																																																															
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																								

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
