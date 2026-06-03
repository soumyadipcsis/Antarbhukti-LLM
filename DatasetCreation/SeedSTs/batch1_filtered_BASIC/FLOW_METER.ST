(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	23. jan. 2011
programmer 	hugo
tested by	oscat

Flow meter measures flow according to gated time or pulses.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FLOW_METER

(*Group:Default*)


VAR_INPUT
	VX :	REAL;
	E :	BOOL;
	RST :	BOOL;
	PULSE_MODE :	BOOL;
	UPDATE_TIME :	TIME := T#1s;
END_VAR


VAR_OUTPUT
	F :	REAL;
END_VAR


VAR_IN_OUT
	X :	REAL;
	Y :	UDINT;
END_VAR


VAR
	T_PLC_MS :	T_PLC_MS;
	tx :	TIME;
	tl :	TIME;
	int1 :	INTEGRATE;
	init :	BOOL;
	e_last :	BOOL;
	tmp :	INT;
	x_last :	REAL;
	y_last :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FLOW_METER
IEC_LANGUAGE: ST
*)
IF NOT init THEN	(* init on power up *)
	init := TRUE;
	tl := tx;
	x_last := X;
	y_last := Y;
	int1.K := 2.7777777777777777E-4;
END_IF;

(* run integrator *)
int1(E := NOT (RST OR PULSE_MODE) AND E, X := VX, Y := X);	(* gated operation *)
X := int1.Y;

IF RST THEN		(* reset *)
	X := 0.0;
	Y := UDINT#0;
	tl := tx;
	x_last := 0.0;
	y_last := UDINT#0;
ELSIF E AND PULSE_MODE THEN	(* check for pulse mode *)
	IF NOT e_last THEN X := X + VX; END_IF;
END_IF;
e_last := E;

(* reduce X to be less than 1 and increase Y respectively *)
IF X > 1.0 THEN
	tmp := FLOOR(X);
	Y := Y + _INT_TO_UDINT(tmp);
	X := X - INT_TO_REAL(tmp);
END_IF;

(* calculate the current flow *)
T_PLC_MS();
tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
IF tx - tl >= UPDATE_TIME AND UPDATE_TIME > t#0s THEN
	F := (UDINT_TO_REAL(Y - y_last) + X - x_last) / TIME_TO_REAL(tx - tl) * 3.6E6;
	y_last := Y;
	x_last := X;
	tl := tx;
END_IF;

(* revision history
hm	23. jan. 2011	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
