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
tested by		tobias

this functiob block can scale up to two inputs.
the input can select between two values with true or false.
the summed output is then scaled by an scale input K and a offset O can be added to the output.
the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE_X2:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	BOOL;
	IN2 :	BOOL;
	K :	REAL;
	O :	REAL;
	IN1_MIN :	REAL;(*Standard = 0*)
	IN1_MAX :	REAL;(*Standard = 1000*)
	IN2_MIN :	REAL;(*Standard = 0*)
	IN2_MAX :	REAL;(*Standard = 1000*)
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE_X2
IEC_LANGUAGE: ST
*)
SCALE_X2 := (SEL(IN1,IN1_MIN, IN1_MAX)+ SEL(IN2,IN2_MIN, IN2_MAX))* k + o;

(* revision history
hm	19. jan, 2007	rev 1.0
	original version

hm	26. oct. 2008	rev 1.1
	code optimized

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
