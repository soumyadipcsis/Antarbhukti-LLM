(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.4	8. mar. 2009
programmer 	oscat
tested BY	oscat

METER measures usage of power or similar values the output MX is the sum of the inputs over time.
MX := sum over time of (I1 * P1 + I2 * P2)/D.
a simple example is the consumption counter for a 2 stage oil burner where stage 1 is 10KW and stage 2 is 20KW.
I1 and I2 decide which value is accounted for, I1 = True only counts P1, I2 is True counts P2 
and I1 and I2 is true counts P1 and P2.
the meter can be used for all kind of consumption meters. P1 and P2 can change on the fly.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK METER

(*Group:Default*)


VAR_INPUT
	M1 :	REAL;
	M2 :	REAL;
	I1 :	BOOL;
	I2 :	BOOL;
	D :	REAL := 1.0;
	RST :	BOOL;
END_VAR


VAR_IN_OUT
	MX :	REAL;
END_VAR


VAR RETAIN 
	MR :	REAL2;
END_VAR


VAR
	MX1 :	REAL;(*current consumption value on M1 and M2*)
	MX2 :	REAL;(*current consumption value on M1 and M2*)
	tx :	UDINT;
	last :	UDINT;
	tc :	REAL;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
	R2_ADD :	R2_ADD;
END_VAR


(*@KEY@: WORKSHEET
NAME: METER
IEC_LANGUAGE: ST
*)
(* measure the last cycle time and make sure we onle execute once every millisecond *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;
IF NOT init THEN
	init := TRUE;
	last := tx;
	mr.RX := mx;
	mr.R1 := 0.0;
ELSIF tx = last THEN
	RETURN;
ELSE
	tc := UDINT_TO_REAL(tx - last) * 0.001;
END_IF;
last := tx;

(* reset *)
IF rst THEN
	mr.R1 := 0.0;
	mr.RX := 0.0;
ELSE
	(* current consumption measurement *)
	MX1 := SEL(I1,0.0,M1);
	MX2 := SEL(I2,0.0,M2);
	(* add up the current values in a double real *)
	R2_ADD(X:=MR,Y:=(SEL(I1,0.0,mx1) + SEL(I2, 0.0, mx2)) / D * TC);
	MR:=R2_ADD.R2_ADD;
	(* set the current output value *)
	MX := mr.RX;
END_IF;


(* revision history

hm	16. sep.2007		rev 1.0
	original version

hm	7. feb 2008		rev 1.1
	use new version of ft_int to avoid a counting stop at high values
	deleted unnecessary limits

hm	24. mar. 2008		rev 1.2
	use data_type real2 to extend accuracy to 15 digits total
	do not use ft_int which adds unnecessary overhead

hm	8. feb. 2009		rev 1.3
	changed mx to be I/O
	make sure calculation works for cycle times < 1 ms

hm	8. mar. 2009	rev 1.4
	last was not updated
	code improvements

*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
