(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	2 jan 2008
programmer 	hugo
tested by	tobias

this is a clock divider
each output divides the signal by 2
Q0 = clk / 2 , Q1 = Q0 / 2 and so on.
the outputs have a 50% duty cycle each.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CLK_DIV

(*Group:Default*)


VAR_INPUT
	CLK :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL := FALSE;
	Q1 :	BOOL := FALSE;
	Q2 :	BOOL := FALSE;
	Q3 :	BOOL := FALSE;
	Q4 :	BOOL := FALSE;
	Q5 :	BOOL := FALSE;
	Q6 :	BOOL := FALSE;
	Q7 :	BOOL := FALSE;
END_VAR


VAR
	cnt :	BYTE := 0;
END_VAR


(*@KEY@: WORKSHEET
NAME: CLK_DIV
IEC_LANGUAGE: ST
*)
IF rst THEN
	cnt:= BYTE#0;
	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
	Q4 := FALSE;
	Q5 := FALSE;
	Q6 := FALSE;
	Q7 := FALSE;
ELSIF clk THEN
	cnt:= USINT_TO_BYTE(BYTE_TO_USINT(cnt) + USINT#1);

    Q0 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),0); (* Q0 := cnt.X0; *)
    Q1 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),1); (* Q1 := cnt.X1; *)
    Q2 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),2); (* Q2 := cnt.X2; *)
    Q3 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),3); (* Q3 := cnt.X3; *)
    Q4 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),4); (* Q4 := cnt.X4; *)
    Q5 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),5); (* Q5 := cnt.X5; *)
    Q6 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),6); (* Q6 := cnt.X6; *)
    Q7 := BIT_OF_DWORD(BYTE_TO_DWORD(cnt),7); (* Q7 := cnt.X7; *)

END_IF;

(* revision history
hm	4. aug. 2006	rev 1.0
	original version

hm	2. jan 2008		rev 1.1
	improved performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
