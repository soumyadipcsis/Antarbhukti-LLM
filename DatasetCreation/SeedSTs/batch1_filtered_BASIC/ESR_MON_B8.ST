(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.3	1. dec. 2009
programmer 	hugo
tested by	tobias

ESR_mon_B8 monitores up to 8 binary inputs and reports changes with time stamd and adress label.
the module checks 8 inputs for a change and reports all changes with time and adress stamp to the output.
4 events maximum can be collected at once within the same cycle

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ESR_MON_B8

(*Group:Default*)


VAR_INPUT
	S0 :	BOOL;
	A0 :	oscat_STRING10;
	S1 :	BOOL;
	A1 :	oscat_STRING10;
	S2 :	BOOL;
	A2 :	oscat_STRING10;
	S3 :	BOOL;
	A3 :	oscat_STRING10;
	S4 :	BOOL;
	A4 :	oscat_STRING10;
	S5 :	BOOL;
	A5 :	oscat_STRING10;
	S6 :	BOOL;
	A6 :	oscat_STRING10;
	S7 :	BOOL;
	A7 :	oscat_STRING10;
	DT_IN :	UDINT;
END_VAR


VAR_IN_OUT
	ESR_Out :	oscat_ESR_3;
END_VAR


VAR_OUTPUT
	ESR_FLAG :	BOOL;
END_VAR


VAR
	x0 :	BOOL;
	x1 :	BOOL;
	x2 :	BOOL;
	x3 :	BOOL;
	x4 :	BOOL;
	x5 :	BOOL;
	x6 :	BOOL;
	x7 :	BOOL;
	tx :	TIME;
	cnt :	INT;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: ESR_MON_B8
IEC_LANGUAGE: ST
*)
(* read system timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

ESR_Flag := FALSE;
esr_out[3].typ := BYTE#0;
esr_out[2].typ := BYTE#0;
esr_out[1].typ := BYTE#0;
esr_out[0].typ := BYTE#0;
cnt := 0;

(* check if inputs have chaged and fill buffer *)
IF s0 <> X0 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s0));
	esr_out[cnt].adress := a0;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X0 := S0;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s1 <> X1 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s1));
	esr_out[cnt].adress := a1;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X1 := S1;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s2 <> X2 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s2));
	esr_out[cnt].adress := a2;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X2 := S2;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s3 <> X3 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s3));
	esr_out[cnt].adress := a3;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X3 := S3;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s4 <> X4 AND cnt < 4 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s4));
	esr_out[cnt].adress := a4;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X4 := S4;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s5 <> X5  AND cnt < 4 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s5));
	esr_out[cnt].adress := a5;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X5 := S5;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s6 <> X6  AND cnt < 4 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s6));
	esr_out[cnt].adress := a6;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X6 := S6;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s7 <> X7  AND cnt < 4 THEN
	esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s7));
	esr_out[cnt].adress := a7;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	X7 := S7;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;

(* revision history
hm	26. jan 2007	rev 1.0
	original version

hm	17. sep 2007	rev 1.1
	replaced time() with T_PLC_MS() for compatibility reasons

hm	22. oct. 2008	rev 1.2
	optimized code

hm	1.dec. 2009	rev 1.3
	changed esr_out to be I/O

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
