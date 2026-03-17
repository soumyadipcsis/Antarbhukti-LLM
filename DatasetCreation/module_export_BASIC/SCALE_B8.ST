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

this functiob block can scale up to 8 inputs.
the inputs have their min value at 0 and their max value at 255 while the min and max value can be either positive or negative.
the inputs ramp between min and max values for the respective inputs to be between (0..255).
the summed output is then scaled by an scale input K and a offset O can be added to the output.
the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE_B8:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	BYTE;
	IN2 :	BYTE;
	IN3 :	BYTE;
	IN4 :	BYTE;
	IN5 :	BYTE;
	IN6 :	BYTE;
	IN7 :	BYTE;
	IN8 :	BYTE;
	K :	REAL;
	O :	REAL;
	IN1_MIN :	REAL;(*Standard = 0*)
	IN1_MAX :	REAL;(*Standard = 1000*)
	IN2_MIN :	REAL;(*Standard = 0*)
	IN2_MAX :	REAL;(*Standard = 1000*)
	IN3_MIN :	REAL;(*Standard = 0*)
	IN3_MAX :	REAL;(*Standard = 1000*)
	IN4_MIN :	REAL;(*Standard = 0*)
	IN4_MAX :	REAL;(*Standard = 1000*)
	IN5_MIN :	REAL;(*Standard = 0*)
	IN5_MAX :	REAL;(*Standard = 1000*)
	IN6_MIN :	REAL;(*Standard = 0*)
	IN6_MAX :	REAL;(*Standard = 1000*)
	IN7_MIN :	REAL;(*Standard = 0*)
	IN7_MAX :	REAL;(*Standard = 1000*)
	IN8_MIN :	REAL;(*Standard = 0*)
	IN8_MAX :	REAL;(*Standard = 1000*)
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE_B8
IEC_LANGUAGE: ST
*)
SCALE_B8 := 	(((in1_max - in1_min)* _BYTE_TO_REAL(in1) + (in2_max - in2_min)* _BYTE_TO_REAL(in2) + (in3_max - in3_min)* _BYTE_TO_REAL(in3) + (in4_max - in4_min)* _BYTE_TO_REAL(in4) +
				(in5_max - in5_min)* _BYTE_TO_REAL(in5) + (in6_max - in6_min)* _BYTE_TO_REAL(in6) + (in7_max - in7_min)* _BYTE_TO_REAL(in7) + (in8_max - in8_min)* _BYTE_TO_REAL(in8)) * 0.003921569
				 + in1_min + in2_min + in3_min + in4_min + in5_min + in6_min + in7_min + in8_min) * K + O;


(* revision History
hm	19. jan.2007	rev 1.1
	changed outputs to real to avoid overflow of integer
	added offset for better cascading of scale functions

hm	6. jan. 2008	rev 1.2
	improved performance

hm	26. oct. 2008	rev 1.3
	code optimization

hm	3. nov. 2008	rev 1.4
	used wrong factor in formula

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
