(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	tobias

RAMPS generates output signal which are slew rate and acceleration controlled.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SRAMP

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	A_UP :	REAL;
	A_DN :	REAL;
	VU_MAX :	REAL;
	VD_MAX :	REAL;
	LIMIT_HIGH :	REAL;
	LIMIT_LOW :	REAL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Y :	REAL;
	V :	REAL;
END_VAR


VAR
	cycle_time :	TC_S;
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SRAMP
IEC_LANGUAGE: ST
*)
(* read the system_time in microseconds *)
cycle_time();

(* assure range of inputs *)
A_up := MAX(0.0,A_UP);
A_dn := MIN(0.0,A_dn);
VU_max := MAX(0.0,VU_max);
VD_max := MIN(0.0,VD_MAX);

(* calculate the output offset *)
IF rst OR NOT init THEN
	init := TRUE;
	Y := 0.0;
	V := 0.0;
ELSIF X = Y THEN
	v := 0.0;
ELSIF X > Y THEN
	(* output is too low >> ramp up and brake at the end *)
	(* accelerate the speed and limit to vu_max *)
	v := MIN(v + A_UP * cycle_time.TC, vu_max);
	(* calculate the max speed to be able to brake and select the lowest *)
	v := MIN(SQRT((Y-X) * 2.0 * A_DN), v);
	(* calculate the output and obey limits *)
	y := LIMIT(limit_low, y + MIN(v * cycle_time.TC, X-Y), limit_high);
ELSIF X < Y THEN
	(* output is too high >> ramp dn and brake at the end *)
	(* accelerate the speed and limit to vd_max *)
	v := MAX(v + A_DN * cycle_time.TC, vd_max);
	(* calculate the max speed to be able to brake and select the lowest *)
	v := MAX(-SQRT((Y-X) * 2.0 * A_UP), v);
	(* calculate the output and obey limits *)
	y := LIMIT(limit_low, y + MAX(v * cycle_time.TC, X-Y), limit_high);
END_IF;


(* revision history
hm	13. mar. 2008	rev 1.0
	original version

hm	11. mar. 2009	rev 1.1
	real constants updated to new systax using dot																																																															
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																								

*)



(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
