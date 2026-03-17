(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.0	27 feb 2007
programmer 	hugo
tested by	tobias
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TANK_LEVEL

(*Group:Default*)


VAR_INPUT
	LEVEL :	BOOL;
	LEAK :	BOOL;
	ACLR :	BOOL;
	MAX_VALVE_TIME :	TIME;
	LEVEL_DELAY_TIME :	TIME;
END_VAR


VAR_OUTPUT
	VALVE :	BOOL;
	ALARM :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	cx :	ACTUATOR_COIL;
	tn :	TON;
	tl :	TONOF;
	open :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TANK_LEVEL
IEC_LANGUAGE: ST
*)
(* preprocess the level information *)
tl(in := level, T_ON := level_delay_time, T_OFF := level_delay_time);
open := tl.Q;

(* start logic *)
IF ALARM THEN
	(* check for ACLR if ALARM is present *)
	IF ACLR THEN
		ALARM := FALSE;
		STATUS := BYTE#101; (* aclr pressed *)
		cx(in := FALSE);
	END_IF;
	RETURN;
ELSIF LEAK THEN
	(* leakeage detected *)
	cx(in := FALSE);
	ALARM := TRUE;
	STATUS := BYTE#1;	(* leakeage error *)
ELSIF open THEN
	(* valve needs to be opened because level is too low *)
	cx(in := TRUE);
	STATUS := BYTE#102; (* valve open by low level *)
ELSE
	(* valve needs to be closed *)
	cx(in := FALSE);
	STATUS := BYTE#100; (* valve idle *)
END_IF;

(* check if valve is open too long and generate alarm if necessary *)
tn(in := cx.out AND (MAX_VALVE_TIME > T#0s), PT := MAX_VALVE_TIME);
IF tn.Q THEN
	ALARM := TRUE;
	STATUS := BYTE#2; (* overtime error *)
	cx(in := FALSE);
END_IF;

(* set output signal *)
VALVE := cx.out;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
