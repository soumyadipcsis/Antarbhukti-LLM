(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.2	11. mar. 2009
programmer 	hugo
tested by	tobias

tune generates an output signal which is set by input switches.
up to 4 switsches can be used to tune the signal up or down.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TUNE

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	SU :	BOOL;
	SD :	BOOL;
	RST :	BOOL;
	SS :	REAL := 0.1;
	LIMIT_L :	REAL;
	LIMIT_H :	REAL := 100.0;
	RST_VAL :	REAL;
	SET_VAL :	REAL := 100.0;
	T1 :	TIME := T#500ms;
	T2 :	TIME := T#2s;
	S1 :	REAL := 2.0;
	S2 :	REAL := 10.0;
END_VAR


VAR_OUTPUT
	Y :	REAL;
END_VAR


VAR
	tx :	UDINT;
	start :	UDINT;
	start2 :	UDINT;
	state :	INT;
	in :	BOOL;
	step :	REAL;
	speed :	REAL;
	Y_start :	REAL;
	Y_start2 :	REAL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: TUNE
IEC_LANGUAGE: ST
*)
(* read system_time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

IF rst THEN
	Y := RST_val;
	state := 0;
ELSIF set THEN
	Y := SET_val;
	state := 0;
ELSIF state > 0 THEN
	(* key has been pushed state machine operating *)
	(* first read the correct input *)
	IF state = 1 THEN
		(* step up *)
		in := su;
	ELSE
		(* step down *)
		in := sd;
	END_IF;
	(* check for single step operation *)
	IF NOT in AND tx - start <= TIME_TO_UDINT(T1) THEN
		Y := Y_start + step;
		state := 0;
	(* check if fast ramp needs to be generated *)
	ELSIF in AND tx - start >= TIME_TO_UDINT(T2) THEN
		Y := Y_start2 + UDINT_TO_REAL(tx - start2) * s2 / speed;
	(* check if slow ramp needs to be generated *)
	ELSIF in AND tx - start >= TIME_TO_UDINT(T1) THEN
		Y := Y_start + UDINT_TO_REAL(tx - start - TIME_TO_UDINT(T1)) * S1 / speed;
		start2 := tx;
		Y_start2 := Y;
	ELSIF NOT in THEN
		state := 0;
	END_IF;
ELSIF su THEN
	(* slow step up *)
	state := 1;
	start := tx;
	step := ss;
	speed := 1000.0;
	Y_start := Y;
ELSIF sd THEN
	(* slow step down *)
	state := 2;
	start := tx;
	step := -ss;
	speed := -1000.0;
	Y_start := Y;
END_IF;

(* make sure output does not exceed limits *)
Y := LIMIT(LIMIT_L, Y, LIMIT_H);

(* revision history
hm	3.11.2007		rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	added type conversions to avoid warnings under codesys 3.0

hm	11. mar. 2009	rev 1.2
	real constants updated to new systax using dot																																																															
																																																																											
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
