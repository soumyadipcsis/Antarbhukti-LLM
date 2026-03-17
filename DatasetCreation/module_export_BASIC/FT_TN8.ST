(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	15 Sep 2007
programmer 	hugo
tested by	tobias

FT_TN8 is delay function, it will delay a signal by a specified time : T and will store 8 values of in before they are put thru to out.
if higher resolution is needed, pls use FT_TN16 or FT_TN64 instead.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_TN8

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	T :	TIME;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
	TRIG :	BOOL;
END_VAR


VAR
	length :	INT := 8;
	X :	oscat_arr_0_7;
	cnt :	INT;
	last :	TIME;
	tx :	TIME;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_TN8
IEC_LANGUAGE: ST
*)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

trig := FALSE;
IF NOT init THEN
	x[cnt] := in;
	init := TRUE;
	last := tx;
ELSIF tx - last >= T / INT_TO_TIME(length) THEN
	IF cnt = length - 1 THEN cnt := 0; ELSE cnt := cnt + 1; END_IF;
	Out := X[cnt];
	x[cnt] := in;
	last := tx;
	trig := TRUE;
END_IF;

(* revision history
hm		1. jan 2007		rev 1.0
	original version

hm		16. sep 2007	rev 1.1
	changes time() to T_plc_ms() for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
