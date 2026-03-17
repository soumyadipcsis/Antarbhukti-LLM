(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.4	1. dec. 2009
programmer 	hugo
tested by	tobias

ESR_mon_R4 monitores up to 4 Real inputs and reports changes with time stamd and adress label.
the module checks 4 inputs for a change of more than the specified sensitivity S and reports all changes with time and adress stamp to the output.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ESR_MON_R4

(*Group:Default*)


VAR_INPUT
	R0 :	REAL;
	A0 :	oscat_STRING10;
	S0 :	REAL;
	R1 :	REAL;
	A1 :	oscat_STRING10;
	S1 :	REAL;
	R2 :	REAL;
	A2 :	oscat_STRING10;
	S2 :	REAL;
	R3 :	REAL;
	A3 :	oscat_STRING10;
	S3 :	REAL;
	DT_IN :	UDINT;
END_VAR


VAR_IN_OUT
	ESR_OUT :	oscat_ESR_3;
END_VAR


VAR_OUTPUT
	ESR_FLAG :	BOOL;
END_VAR


VAR
	x0 :	REAL;
	x1 :	REAL;
	x2 :	REAL;
	x3 :	REAL;
	tx :	TIME;
	cnt :	INT;
	T_PLC_MS :	T_PLC_MS;
	REAL_TO_DW :	REAL_TO_DW;
	tmp :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: ESR_MON_R4
IEC_LANGUAGE: ST
*)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

ESR_Flag := FALSE;
esr_out[3].typ := BYTE#0;
esr_out[2].typ := BYTE#0;
esr_out[1].typ := BYTE#0;
esr_out[0].typ := BYTE#0;
cnt := 0;

(* check if inputs have chaged and fill buffer *)
IF differ(R0, X0, S0) THEN
    REAL_TO_DW(X:=R0);
    tmp := REAL_TO_DW.REAL_TO_DW;

	esr_out[cnt].typ := BYTE#20;
	esr_out[cnt].adress := a0;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
	esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
	esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
	esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
	X0 := R0;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF differ(R1, X1, S1) THEN
    REAL_TO_DW(X:=R1);
    tmp := REAL_TO_DW.REAL_TO_DW;

	esr_out[cnt].typ := BYTE#20;
	esr_out[cnt].adress := a1;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
	esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
	esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
	esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
	X1 := R1;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF differ(R2, X2, S2) THEN
    REAL_TO_DW(X:=R2);
    tmp := REAL_TO_DW.REAL_TO_DW;

	esr_out[cnt].typ := BYTE#20;
	esr_out[cnt].adress := a2;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
	esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
	esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
	esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
	X2 := R2;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;
IF differ(R3, X3, S3) THEN
    REAL_TO_DW(X:=R2);
    tmp := REAL_TO_DW.REAL_TO_DW;

	esr_out[cnt].typ := BYTE#20;
	esr_out[cnt].adress := a3;
	esr_out[cnt].DS := DT_in;
	esr_out[cnt].TS := TX;
	esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
	esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
	esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
	esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
	X3 := R3;
	cnt := cnt + 1;
	esr_flag := TRUE;
END_IF;


(* revision history
hm	26. jan 2007	rev 1.0
	original version

hm	17. sep. 2007		rev 1.1
	replaced time() with T_PLC_MS() for compatibility reasons

hm	8. dec. 2007		rev 1.2
	corrected an error while esr typ would not be set

hm	16. mar. 2008		rev 1.3
	deleted wrong conversion real_to_dword

hm	1. dec 2009		rev 1.4
	changed esr_out to be I/O

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
