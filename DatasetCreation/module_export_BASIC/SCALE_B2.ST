(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.4	3. nov. 2008
programmer 	hugo
tested by	oscat

this functiob block can scale up to two inputs.
inputs have their min value at 0 and their max value at 255 while the min and max value can be either positive or negative.
inputs ramp between min and max values for the respective inputs to be between (0..255).
the summed output is then scaled by an scale input K and a offset O can be added to the output.
min and max input configurations can be edited in the cfc editor by double clicking the symbol body.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE_B2:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	BYTE;
	IN2 :	BYTE;
	K :	REAL;(*Standard = 1*)
	O :	REAL;(*Standard = 0*)
	IN1_MIN :	REAL;(*Standard = 0*)
	IN1_MAX :	REAL;(*Standard = 1000*)
	IN2_MIN :	REAL;(*Standard = 0*)
	IN2_MAX :	REAL;(*Standard = 1000*)
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE_B2
IEC_LANGUAGE: ST
*)
SCALE_B2 := 	(((in1_max - in1_min)* _BYTE_TO_REAL(in1) + (in2_max - in2_min)* _BYTE_TO_REAL(in2)) * 0.003921569 + in1_min + in2_min) * K + O;

(* code bofore rev 1.2
scale_B2 := 	((in1_max - in1_min)* in1 / 255 + in1_min +
				(in2_max - in2_min)* in2 / 255 + in2_min)
				* K + O;
*)

(* revision History
hm 19.1.2007		rev 1.1
	changed outputs to real to avoid overflow of integer
	added offset for better cascading of scale functions
	changed from FB to function

hm	6. jan 2008		rev 1.2
	improved performance

hm	26. oct. 2008	rev 1.3
	code optimization

hm	3. nov. 2008	rev 1.4
	used wrong factor in formula

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
