(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	2 jan 2008
programmer 	hugo
tested by	tobias

driver_4 is a multi purpose driver.
a rising edge in in sets the output high if toggle is flase. while toggle is true, a rising edge on in toggles the output Q.
if a timeout is specified the output q will be reset to false automatically after the timeout has elapsed.
a asynchronous reset and set will force the output high or low respectively.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DRIVER_4

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	IN0 :	BOOL;
	IN1 :	BOOL;
	IN2 :	BOOL;
	IN3 :	BOOL;
	RST :	BOOL;
	TOGGLE_MODE :	BOOL;
	TIMEOUT :	TIME;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
END_VAR


VAR
	d0 :	DRIVER_1;
	d1 :	DRIVER_1;
	d2 :	DRIVER_1;
	d3 :	DRIVER_1;
END_VAR


(*@KEY@: WORKSHEET
NAME: DRIVER_4
IEC_LANGUAGE: ST
*)
D0(Set:=set, in:=in0, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
D1(Set:=set, in:=in1, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
D2(Set:=set, in:=in2, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
D3(Set:=set, in:=in3, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
Q0 := D0.Q;
Q1 := D1.Q;
Q2 := D2.Q;
Q3 := D3.Q;

(* revision history
hm	2. jan 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
