(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. nov. 2008
programmer 	hugo
tested by	oscat

_RMP_B generates a ramp on an external var of type byte
tr is the total ramp time, E is an enable and dir the direction of the ramp
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _RMP_W

(*Group:Default*)


VAR_INPUT
	DIR :	BOOL;
	E :	BOOL := TRUE;
	TR :	TIME;
END_VAR


VAR_IN_OUT
	RMP :	WORD;
END_VAR


VAR
	T_PLC_MS :	T_PLC_MS;
	tx :	UDINT;
	tl :	UDINT;
	step :	DINT;
	init :	BOOL;
	last_dir :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: _RMP_W
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx := T_PLC_MS.T_PLC_MS;
IF E AND init THEN
	(* we need to set tl = tx when direction changes *)
	IF dir XOR last_dir THEN
	 tl := tx;
	 last_dir := dir;
	END_IF;
	(* check_elapsed time and calculate only if necessary *)
	IF tr > t#0s THEN
		step := DWORD_TO_DINT(UDINT_TO_DWORD(DWORD_TO_UDINT(SHL_DWORD(UDINT_TO_DWORD(tx-tl), 16)) / TIME_TO_UDINT(TR)));
	ELSE
		step := DINT#65535;
	END_IF;
	IF step > DINT#0 THEN
		(* perform the step on the ramp *)
		tl := tx;
		(* calculate the step response *)
		IF NOT dir THEN step := - step; END_IF;
		rmp := DINT_TO_WORD(LIMIT(DINT#0, _WORD_TO_DINT(rmp) + step, DINT#65535));
	END_IF;
ELSE
	tl := tx;
	init := TRUE;
END_IF;

(* revison history
hm	22. oct. 2008	rev 1.0
	original version

hm	20. nov. 2008	rev 1.1
	set default for E to be TRUE
	added init

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
