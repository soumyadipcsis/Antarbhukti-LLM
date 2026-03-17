(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0	19 jan 2007
programmer 	hugo
tested by	tobias

this function can scale up to 4 inputs.
the input can select between two values with true or false.
the summed output is then scaled by an scale input K and a offset O can be added to the output.
the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE_X4:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	BOOL;
	IN2 :	BOOL;
	IN3 :	BOOL;
	IN4 :	BOOL;
	K :	REAL;
	O :	REAL;
	IN1_MIN :	REAL;
	IN1_MAX :	REAL;
	IN2_MIN :	REAL;
	IN2_MAX :	REAL;
	IN3_MIN :	REAL;
	IN3_MAX :	REAL;
	IN4_MIN :	REAL;
	IN4_MAX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE_X4
IEC_LANGUAGE: ST
*)
IF NOT in1 THEN scale_X4 := in1_min; ELSE scale_X4 := in1_max; END_IF;
IF NOT in2 THEN scale_x4 := scale_x4 + in2_min; ELSE scale_x4 := scale_x4 + in2_max; END_IF;
IF NOT in3 THEN scale_x4 := scale_x4 + in3_min; ELSE scale_x4 := scale_x4 + in3_max; END_IF;
IF NOT in4 THEN scale_x4 := scale_x4 + in4_min; ELSE scale_x4 := scale_x4 + in4_max; END_IF;
scale_X4 := scale_X4 * k + O;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
