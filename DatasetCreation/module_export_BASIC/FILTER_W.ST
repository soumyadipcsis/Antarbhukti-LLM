(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.2	25. jan. 2011
programmer 	hugo
tested by	oscat

FILTER_W is an low pass filter with a programmable time T used for WORD format.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILTER_W

(*Group:Default*)


VAR_INPUT
	X :	WORD;
	T :	TIME;
END_VAR


VAR_OUTPUT
	Y :	WORD;
END_VAR


VAR
	last :	UDINT;
	tx :	UDINT;
	init :	BOOL;
	tmp :	DINT;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILTER_W
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

(* startup initialisation *)
IF NOT init OR T = T#0s THEN
	init := TRUE;
	last := tx;
	Y := X;
ELSIF Y = X THEN
	last := tx;
ELSE
	tmp := UINT_TO_DINT(WORD_TO_UINT(X) - WORD_TO_UINT(Y)) * UDINT_TO_DINT(tx - last) / TIME_TO_DINT(T);
	IF tmp <> DINT#0 THEN
		Y := DINT_TO_WORD(WORD_TO_DINT(Y) + tmp);
		last := tx;
	END_IF;
END_IF;

(*
hm 10. oct. 2008	rev 1.0
	original version

hm	3. nov. 2008	rev 1.1
	fixed overflow problem in formula

hm	25. jan. 2011	rev 1.2
	fixed error in formula
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
