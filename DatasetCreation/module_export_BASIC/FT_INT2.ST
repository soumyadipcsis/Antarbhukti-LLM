(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.2	11. mar. 2009
programmer 	hugo
tested by	oscat

FT_int2 is an integrator with input IN and factor K.
integration is only done while run = true, if run is false integration is stopped and the out remains at the last value.
if run is left unconnected, run is considered true by the function block.
the out_min and out_max values can be set to ,imit the output value range. 
the default for K is 1.
FT_INT2 has double presision accuracy (14 digits).
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_INT2

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	K :	REAL := 1.0;
	RUN :	BOOL := TRUE;
	RST :	BOOL;
	OUT_MIN :	REAL := REAL#-1.0E-37;
	OUT_MAX :	REAL := REAL#1.0E37;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
	LIM :	BOOL;
END_VAR


VAR
	integ :	INTEGRATE;
	ix :	REAL;
	val :	REAL2;
	R2_ADD :	R2_ADD;
	R2_SET :	R2_SET;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_INT2
IEC_LANGUAGE: ST
*)
IF RST THEN
	R2_SET(X:=0.0);
	val:=R2_SET.R2_SET;
	out := 0.0;
ELSE
	integ(X := IN, E := RUN, K := K, Y := ix);
	ix := integ.Y;
	R2_ADD(X:=val,Y:=ix);
	val:=R2_ADD.R2_ADD;
	ix := 0.0;
	OUT := val.RX;
END_IF;

(* check output for limits *)
IF out > OUT_MIN AND out < OUT_MAX THEN
	LIM := FALSE;
ELSE
	OUT := LIMIT(OUT_MIN, OUT, OUT_MAX);
	R2_SET(X:=OUT);
	val:=R2_SET.R2_SET;
	LIM := TRUE;
END_IF;



(*	revision history
hm	2. jun. 2008	rev 1.0
	original version

hm	5. nov. 2008	rev 1.1
	rewritten code using integrate

hm	11. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
