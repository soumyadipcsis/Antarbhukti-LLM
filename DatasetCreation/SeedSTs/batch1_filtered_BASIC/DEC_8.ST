(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.3	28. mar. 2009
programmer 	hugo
tested by	oscat

a bit input will be decoded to one of the 8 outputs
dependent on the Adress on A0, A1 and A2

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DEC_8

(*Group:Default*)


VAR_INPUT
	D :	BOOL;
	A0 :	BOOL;
	A1 :	BOOL;
	A2 :	BOOL;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	Q4 :	BOOL;
	Q5 :	BOOL;
	Q6 :	BOOL;
	Q7 :	BOOL;
END_VAR


VAR
	X :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEC_8
IEC_LANGUAGE: ST
*)
X:=BIT_LOAD_B(X,A0,0); (* X.0 := A0; *)
X:=BIT_LOAD_B(X,A1,1); (* X.1 := A1; *)
X:=BIT_LOAD_B(X,A2,2); (* X.2 := A2; *)

Q0 := FALSE;
Q1 := FALSE;
Q2 := FALSE;
Q3 := FALSE;
Q4 := FALSE;
Q5 := FALSE;
Q6 := FALSE;
Q7 := FALSE;

CASE _BYTE_TO_INT(X) OF
	0 : Q0 := D;
	1 : Q1 := D;
	2 : Q2 := D;
	3 : Q3 := D;
	4 : Q4 := D;
	5 : Q5 := D;
	6 : Q6 := D;
	7 : Q7 := D;
END_CASE;

(* revision history
hm 3. mar. 2007	rev 1.1
	rewritten in ST for better compatibility

hm	26. oct. 2008	rev 1.2
	code optimized

hm	28. mar. 2009	rev 1.3
	replaced multiple assignments
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
