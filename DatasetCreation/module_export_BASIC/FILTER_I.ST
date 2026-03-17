(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0	8. nov. 2008
programmer 	hugo
tested by	oscat

FILTER_I is a low pass filter with a programmable time T used for INT format.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILTER_I

(*Group:Default*)


VAR_INPUT
	X :	INT;
	T :	TIME;
END_VAR


VAR_OUTPUT
	Y :	INT;
END_VAR


VAR
	Yi :	DINT;
	last :	UDINT;
	tx :	UDINT;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILTER_I
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

(* startup initialisation *)
IF NOT init OR T = t#0s THEN
	init := TRUE;
	Yi := INT_TO_DINT(X) * DINT#1000;
ELSE
	(* to increase accuracy of the filter we calculate internal Yi wich is Y * 1000 *)
	Yi := Yi + INT_TO_DINT(X - Y) * UDINT_TO_DINT(tx - last) * DINT#1000 / TIME_TO_DINT(T);
END_IF;
last := tx;
Y := DINT_TO_INT(yi / DINT#1000);



(*
hm 8. nov. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
