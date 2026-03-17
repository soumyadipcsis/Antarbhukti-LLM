(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 2.0	30. jun. 2008
programmer 	hugo
tested by	oscat

FT_PI is a PI controller with manual functionality.
The PID controller works according to the fomula Y = e *(KP+ KI * INTEG(e) ) + offset, while e = set_point - actual.
a rst will reset all internal data, while a switch to manual will cause the controller to follow the function Y = manual_in + offset.
limit_h and Limit_l set the possible output range of Y.
the output flags lim will signal that the output limits are active.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CTRL_PID

(*Group:Default*)


VAR_INPUT
	ACT :	REAL;
	SET :	REAL;
	SUP :	REAL;
	OFS :	REAL;
	M_I :	REAL;
	MAN :	BOOL;
	RST :	BOOL := FALSE;
	KP :	REAL := 1.0;
	TN :	REAL := 1.0;
	TV :	REAL := 1.0;
	LL :	REAL := -1000.0;
	LH :	REAL := 1000.0;
END_VAR


VAR_OUTPUT
	Y :	REAL;
	DIFF :	REAL;
	LIM :	BOOL;
END_VAR


VAR
	pid :	FT_PIDWL;
	co :	CTRL_OUT;
END_VAR


(*@KEY@: WORKSHEET
NAME: CTRL_PID
IEC_LANGUAGE: ST
*)
DIFF := CTRL_IN(SET, ACT, SUP);
pid(in := DIFF, kp := KP, tn := TN, tv := TV, lim_l := LL, lim_h := LH, rst := RST);
co(ci := pid.Y, OFFSET := OFS, man_in := M_I, lim_l := LL, lim_h := LH, manual := MAN);
Y := co.Y;
LIM := co.LIM;

(* revision history
hm 	31.10.2007 		rev 1.0
	original version

hm	3.11.2007		rev 1.1
	added noise input to filter noise
	added output diff
	set limit output false when output is within limits
	overfolw was not set correctly

hm	5. jan 2008		rev 1.2
	improved performance

hm	30. jun. 2008	rev 2.0
	rewritten using new modular approach

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
