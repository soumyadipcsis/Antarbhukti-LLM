(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
ersion 1.1	3. nov. 2008
programmer 	hugo
tested by	oscat

FILTER_DW is an low pass filter with a programmable time T used for DWORD format.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILTER_DW

(*Group:Default*)


VAR_INPUT
	X :	DWORD;
	T :	TIME;
END_VAR


VAR_OUTPUT
	Y :	DWORD;
END_VAR


VAR
	last :	UDINT;
	tx :	UDINT;
	init :	BOOL;
	Yi :	REAL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILTER_DW
IEC_LANGUAGE: ST
*)
(* read system_time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

(* startup initialisation *)
IF NOT init OR T = t#0s THEN
	init := TRUE;
	Yi := _DWORD_TO_REAL(X);
ELSE
	Yi := Yi + (_DWORD_TO_REAL(X) - _DWORD_TO_REAL(Y)) * UDINT_TO_REAL(tx - last) / TIME_TO_REAL(T);
END_IF;
last := tx;

Y := _REAL_TO_DWORD(Yi);

(*
hm 10. oct. 2008	rev 1.0
	original version

hm	3. nov. 2008	REV 1.1
	corrected an overflow problem
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
