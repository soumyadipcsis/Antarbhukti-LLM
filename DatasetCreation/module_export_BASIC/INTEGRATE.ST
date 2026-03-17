(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	3. nov. 2008
programmer 	hugo
tested by	oscat

integrate is a plain integrator with I/O for out.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK INTEGRATE

(*Group:Default*)


VAR_INPUT
	E :	BOOL := TRUE;
	X :	REAL;
	K :	REAL := 1.0;
END_VAR


VAR_IN_OUT
	Y :	REAL;
END_VAR


VAR
	X_last :	REAL;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
	last :	UDINT;
	tx :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: INTEGRATE
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

IF NOT init THEN
	init := TRUE;
	X_last := X;
ELSIF E THEN
	Y := (X + X_LAST) * 0.5E-3 * UDINT_TO_REAL(tx-last) * K + Y;
	X_last := X;
END_IF;
last := tx;



(*
hm 	3. nov. 2008	rev 1.0
original version
	
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
