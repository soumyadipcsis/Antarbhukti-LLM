(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ACTUATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0 3. nov. 2008	
programmer 	hugo
tested by	oscat

ACTUATOR_A drives any valve or similar with 0 - 100% analog control.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ACTUATOR_A

(*Group:Default*)


VAR_INPUT
	I1 :	BYTE;
	IS :	BOOL;
	I2 :	BYTE;
	RV :	BOOL;
	DX :	BOOL;
	RUNTIME :	TIME;
	SELF_ACT_TIME :	TIME;
	OUT_MIN :	DWORD;
	OUT_MAX :	DWORD;
END_VAR


VAR_OUTPUT
	Y :	DWORD;
END_VAR


VAR
	timer :	CYCLE_4;
	dx_edge :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ACTUATOR_A
IEC_LANGUAGE: ST
*)
(* run the system timer, if self_act_time = t#0s then state is set to 0 *)
timer(T0 := RUNTIME, T1 := RUNTIME, T3 := SELF_ACT_TIME, sl := DX AND NOT dx_edge, sx := 0, S0 := SELF_ACT_TIME > t#0s);
dx_edge := dx;

CASE timer.STATE OF
	0: 	(* self act min value *)
		Y := OUT_MIN;
	1:	(* self_act max value *)
		Y := OUT_MAX;
	3:	(* normal operation *)
		IF rv THEN
			Y := UDINT_TO_DWORD(DWORD_TO_UDINT(OUT_MAX) - (DWORD_TO_UDINT(OUT_MAX) - DWORD_TO_UDINT(OUT_MIN)) * BYTE_TO_UDINT(SEL(IS, I1, I2)) / UDINT#255);
		ELSE
			Y := UDINT_TO_DWORD((DWORD_TO_UDINT(OUT_MAX) - DWORD_TO_UDINT(OUT_MIN)) * BYTE_TO_UDINT(SEL(IS, I1, I2)) / UDINT#255 + DWORD_TO_UDINT(OUT_MIN));
		END_IF;
END_CASE;

(*
hm 	3. nov. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
