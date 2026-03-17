(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.5	11. mar. 2009
programmer 	hugo
tested by	oscat

FT_PT2 is a 2nd grade filter with programmable times T, D and faktor K.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_PT2

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	T :	TIME;
	D :	REAL;
	K :	REAL := 1.0;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
END_VAR


VAR
	init :	BOOL;
	int1 :	INTEGRATE;
	int2 :	INTEGRATE;
	tn :	REAL;
	I1 :	REAL;
	I2 :	REAL;
	tn2 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_PT2
IEC_LANGUAGE: ST
*)
(* startup initialisation *)
IF NOT init OR T = T#0s THEN
	init := TRUE;
	out := K * in;
	I2 := out;
ELSE
	TN := TIME_TO_REAL(T) / 1000.0;
	tn2 := TN * TN;
	int1(X := in * K / tn2 - I1 * 0.5 * D / TN - I2 / TN2, Y := I1);
	I1 := int1.Y;
	int2(X := I1,Y := I2);
	I2 := int2.Y;
	out := I2;
END_IF;

(* revision history

15.1.2007 hm		rev 1.1
	changed formula to new more acurate formula

hm 15.9.2007		rev 1.2
	deleted unused code for init system time reading tx	

hm	30.11.2007	rev 1.3
	changed out to be K * in during initialization
	avoind divide by 0 if tn = 0

hm	3. nov. 2008	rev 1.4
	optimized code and fixed a problem with init

hm	11. mar. 2009	rev 1.5
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
