(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	22. mar. 2009
programmer 	hugo
tested by	tobias

this is an intelligent dimmer interface with an autoset feature using double switch inputs
a configurable debounce timer will debounce the input signals
if t_on_max is set to anything other then 0 the output will be turned off after the max on time is reached.
the times for debounce, dimming ramp, wait time before dimming and max on time are all programmable.

the dimmer has outputs Q for on and off and also out with the analog dimm value.
two additional outputs d1 and d2 decode double clicks on i1 and i2.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DIMM_2

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	VAL :	BYTE := BYTE#255;
	I1 :	BOOL;
	I2 :	BOOL;
	RST :	BOOL;
	T_DEBOUNCE :	TIME := T#10ms;
	T_ON_MAX :	TIME := T#0h;
	T_DIMM_START :	TIME := T#1s;
	T_DIMM :	TIME := T#3s;
	MIN_ON :	BYTE := BYTE#50;
	MAX_ON :	BYTE := BYTE#255;
	RST_OUT :	BOOL;
	SOFT_DIMM :	BOOL := TRUE;
	DBL1_TOG :	BOOL;
	DBL2_TOG :	BOOL;
	DBL1_SET :	BOOL;
	DBL2_SET :	BOOL;
	DBL1_POS :	BYTE;
	DBL2_POS :	BYTE;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	D1 :	BOOL;
	D2 :	BOOL;
END_VAR


VAR_IN_OUT
	OUT :	BYTE := BYTE#0;
END_VAR


VAR
	t1 :	TOF;
	t2 :	TOF;
	dc1 :	CLICK_MODE;
	dc2 :	CLICK_MODE;
	t3 :	TON;
	dim :	_RMP_B;
END_VAR


(*@KEY@: WORKSHEET
NAME: DIMM_2
IEC_LANGUAGE: ST
*)
(* debouncing for inputs i1 and i2 *)
t1(IN := I1, PT := T_DEBOUNCE);
t2(IN := I2, PT := T_DEBOUNCE);
dc1(in := t1.Q, T_LONG := T_DIMM_START);
dc2(in := t2.Q, T_LONG := T_DIMM_START);

IF RST THEN
	IF RST_OUT THEN out := BYTE#0; END_IF;
	Q := FALSE;
	D1 := FALSE;
	D2 := FALSE;
ELSIF set THEN
	OUT := VAL;
	Q := TRUE;
ELSIF dc1.SINGLE THEN
	(* single click on i1 turns the dimmer on *)
	out := LIMIT(MAX(MIN_ON,BYTE#1), out, MAX_ON);
	Q := TRUE;
ELSIF dc2.SINGLE THEN
	(* single click on i2 turns the dimmer off *)
	Q := FALSE;
ELSIF dc1.TP_LONG THEN
	(* continuous on at i1 dimms up *)
	IF NOT Q THEN
		out := SEL(SOFT_DIMM, LIMIT(MAX(MIN_ON,BYTE#1), out, MAX_ON), BYTE#1);
	END_IF;
	Q := TRUE;
	dim.DIR := TRUE;
ELSIF dc2.TP_LONG THEN
	(* continuous on at i2 dimms down *)
	dim.DIR := FALSE;
END_IF;

(* set the double click output *)
IF NOT DBL1_TOG THEN D1 := FALSE; END_IF;
IF dc1.DOUBLE THEN
	IF DBL1_SET THEN
		OUT := DBL1_POS;
		Q := TRUE;
	ELSE
		D1 := NOT D1;
	END_IF;
END_IF;
IF NOT DBL2_TOG THEN D2 := FALSE; END_IF;
IF dc2.DOUBLE THEN
	IF DBL2_SET THEN
		OUT := DBL2_POS;
		Q := TRUE;
	ELSE
		D2 := NOT D2;
	END_IF;
END_IF;


(* while dimming is active ramp the output out up or down *)
dim(dir := dc2.LONG, e := dc1.LONG OR dc2.LONG , TR := T_DIMM, rmp := out);
out := dim.RMP;

(* turn off output if a value of 0 is reached *)
IF out = BYTE#0 THEN Q := FALSE; END_IF;

(* limit the maximum runtime *)
IF t_ON_MAX > t#0s THEN
	t3(in := q, pt := T_ON_MAX);
	Q := Q XOR t3.Q;
END_IF;




(* revision history

hm 22. mar. 2009	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
