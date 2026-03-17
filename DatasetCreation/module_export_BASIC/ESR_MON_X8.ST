(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.2	1. dec. 2009
programmer 	hugo
tested by	tobias

ESR_MON_X8 is a status and error collector.
the module checks 8 status inputs for a change and reports up to 4 input changes with time and adress stamp to the output.
the mode can be 
1 for error only
2 for error and status
3 for error, status and debug
the adress label of the 8 inputs can be configured individually.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ESR_MON_X8

(*Group:Default*)


VAR_INPUT
	S0 :	BYTE;
	A0 :	oscat_STRING10;
	S1 :	BYTE;
	A1 :	oscat_STRING10;
	S2 :	BYTE;
	A2 :	oscat_STRING10;
	S3 :	BYTE;
	A3 :	oscat_STRING10;
	S4 :	BYTE;
	A4 :	oscat_STRING10;
	S5 :	BYTE;
	A5 :	oscat_STRING10;
	S6 :	BYTE;
	A6 :	oscat_STRING10;
	S7 :	BYTE;
	A7 :	oscat_STRING10;
	DT_IN :	UDINT;
	MODE :	BYTE := BYTE#3;
END_VAR


VAR_IN_OUT
	ESR_OUT :	oscat_ESR_3;
END_VAR


VAR_OUTPUT
	ESR_FLAG :	BOOL;
END_VAR


VAR
	x0 :	BYTE;
	x1 :	BYTE;
	x2 :	BYTE;
	x3 :	BYTE;
	x4 :	BYTE;
	x5 :	BYTE;
	x6 :	BYTE;
	x7 :	BYTE;
	tx :	TIME;
	cnt :	INT;
	status_to_ESR :	status_to_ESR;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: ESR_MON_X8
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
IF s0 <> X0 AND ((s0 < BYTE#100) OR (S0 > BYTE#99 AND S0 < BYTE#200 AND mode >= BYTE#2) OR (S0 > BYTE#199 AND mode = BYTE#3)) THEN
    
    status_to_ESR.status := s0;
    status_to_ESR.adress := a0;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X0 := S0;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s1 <> X1 AND ((s1 < BYTE#100) OR (S1 > BYTE#99 AND S1 < BYTE#200 AND mode >= BYTE#2) OR (S1 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s1;
    status_to_ESR.adress := a1;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X1 := S1;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s2 <> X2 AND ((s2 < BYTE#100) OR (S2 > BYTE#99 AND S2 < BYTE#200 AND mode >= BYTE#2) OR (S2 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s2;
    status_to_ESR.adress := a2;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X2 := S2;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF s3 <> X3 AND ((s3 < BYTE#100) OR (S3 > BYTE#99 AND S3 < BYTE#200 AND mode >= BYTE#2) OR (S3 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s3;
    status_to_ESR.adress := a3;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X3 := S3;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF cnt < 4 AND s4 <> X4 AND ((s4 < BYTE#100) OR (S4 > BYTE#99 AND S4 < BYTE#200 AND mode >= BYTE#2) OR (S4 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s4;
    status_to_ESR.adress := a4;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X4 := S4;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF cnt < 4 AND s5 <> X5 AND ((s5 < BYTE#100) OR (S5 > BYTE#99 AND S5 < BYTE#200 AND mode >= BYTE#2) OR (S5 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s5;
    status_to_ESR.adress := a5;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X5 := S5;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF cnt < 4 AND s6 <> X6 AND ((s6 < BYTE#100) OR (S6 > BYTE#99 AND S6 < BYTE#200 AND mode >= BYTE#2) OR (S6 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s6;
    status_to_ESR.adress := a6;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X6 := S6;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF cnt < 4 AND s7 <> X7 AND ((s7 < BYTE#100) OR (S7 > BYTE#99 AND S7 < BYTE#200 AND mode >= BYTE#2) OR (S7 > BYTE#199 AND mode = BYTE#3)) THEN

    status_to_ESR.status := s7;
    status_to_ESR.adress := a7;
    status_to_ESR.DT_in  := DT_in;
    status_to_ESR.TS     := tx;
    status_to_ESR();
    esr_out[cnt] := status_to_ESR.status_to_ESR;

	X7 := S7;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;

(* revision history
hm	26. jan 2007		rev 1.0
	original version

hm	17. sep 2007	rev 1.1
	replaced time() with T_PLC_MS() for compatibility reasons

hm	1. dec. 2009	rev 1.2
	changed esr_out to be I/O


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
