(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	13 dec 2007
programmer 	hugo
tested by	tobias

this function generates one out of 4 signals specified by bit patterns S1 .. S4.
the selected pattern will be shifted with the step time TS.
In1 has higher priority then In2 which has higher priority then IN3 and in4 has the lowest priority.
ts defaults to 128 ms if not specified.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SIGNAL_4

(*Group:Default*)


VAR_INPUT
	IN1 :	BOOL;
	IN2 :	BOOL;
	IN3 :	BOOL;
	IN4 :	BOOL;
	TS :	TIME;
	S1 :	BYTE := 2#1111_1111;
	S2 :	BYTE := 2#1111_0000;
	S3 :	BYTE := 2#1010_1010;
	S4 :	BYTE := 2#1010_0000;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	sig :	signal;
END_VAR


(*@KEY@: WORKSHEET
NAME: SIGNAL_4
IEC_LANGUAGE: ST
*)
(* an alarm is present read system time first *)
(* check if an alarm is present if yes set sig to the alarm pattern otherwise exit the routine *)
IF in1 THEN
	sig(in := TRUE, sig := s1, TS := TS);
ELSIF in2 THEN
	sig(in := TRUE, sig := s2, TS := TS);
ELSIF in3 THEN
	sig(in := TRUE, sig := s3, TS := TS);
ELSIF in4 THEN
	sig(in := TRUE, sig := s4, TS := TS);
ELSE
	sig(in := FALSE);
END_IF;

(* set the output *)
Q := sig.Q;

(* revision history
hm	13.12.2007		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
