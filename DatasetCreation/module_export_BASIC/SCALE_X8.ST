(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.2	24. jan. 2009
programmer 	hugo
tested by	oscat

this function can scale up to 4 inputs.
the input can select between two values with true or false.
the summed output is then scaled by an scale input K and a offset O can be added to the output.
the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE_X8:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	BOOL;
	IN2 :	BOOL;
	IN3 :	BOOL;
	IN4 :	BOOL;
	IN5 :	BOOL;
	IN6 :	BOOL;
	IN7 :	BOOL;
	IN8 :	BOOL;
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
	IN5_MIN :	REAL;
	IN5_MAX :	REAL;
	IN6_MIN :	REAL;
	IN6_MAX :	REAL;
	IN7_MIN :	REAL;
	IN7_MAX :	REAL;
	IN8_MIN :	REAL;
	IN8_MAX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE_X8
IEC_LANGUAGE: ST
*)
SCALE_X8 := (SEL(IN1,IN1_MIN, IN1_MAX)+ SEL(IN2,IN2_MIN, IN2_MAX)+SEL(IN3,IN3_MIN, IN3_MAX)+ SEL(IN4,IN4_MIN, IN4_MAX)
				+SEL(IN5,IN5_MIN, IN5_MAX)+ SEL(IN6,IN6_MIN, IN6_MAX)+SEL(IN7,IN7_MIN, IN7_MAX)+ SEL(IN8,IN8_MIN, IN8_MAX))*k + o;

(* revision history
hm	19. jan. 2008	rev 1.0
	original version

hm	26. oct. 2008	rev 1.1
	optimized code

hm	24. jan. 2008	rev 1.2
	corrected error in formula
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
