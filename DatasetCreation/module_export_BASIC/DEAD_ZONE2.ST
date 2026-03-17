(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	tobias

dead_zone2 is a linear transfer function which follows a linear function except for x is close to 0.
Y = X if abs(x) > L.
for values of 0 +/- L a hysteresis function will hold the output at + or - L.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DEAD_ZONE2

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	L :	REAL;
END_VAR


VAR_OUTPUT
	Y :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEAD_ZONE2
IEC_LANGUAGE: ST
*)
IF ABS(x) > L THEN
	Y := X;
ELSIF Y > 0.0 THEN
	Y := L;
ELSE
	Y := -L;
END_IF;



(* revision history

hm	12. feb. 2007	rev 1.0
	original version

hm	11. mar. 2009	rev 1.1
	real constants updated to new systax using dot

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
