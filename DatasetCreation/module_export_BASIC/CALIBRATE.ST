(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	11. mar. 2009
programmer 	hugo
tested BY	hans

Calibrate allows for offset and scale calibration of an analog input.
offset is calibrated to a stored reference Y_offset while CO is true.
after the offset is calibrated, scale can be calibrated to a reference value Y_scale while CS is true.
*)
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CALIBRATE

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	CO :	BOOL;
	CS :	BOOL;
	Y_OFFSET :	REAL;
	Y_SCALE :	REAL;
END_VAR


VAR_OUTPUT
	Y :	REAL;
END_VAR


VAR RETAIN 
	offset :	REAL;
	Scale :	REAL := 1.0;
END_VAR


(*@KEY@: WORKSHEET
NAME: CALIBRATE
IEC_LANGUAGE: ST
*)
(* check for calibration *)
IF CO THEN
	OFFSET := Y_Offset - X;
ELSIF CS THEN
	SCALE := Y_scale / (X + OFFSET);
END_IF;
(* calculate output *)
Y := (X + OFFSET) * SCALE;


(* revision history
hm 22.2.2007		rev 1.2
	changed VAR RETAIN PERSISTENT to VAR RETAIN for better compatibility
	wago lon contollers do not support persisitent

hm	11. mar. 2009	rev 1.3
	changed real constants to use dot syntax

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
