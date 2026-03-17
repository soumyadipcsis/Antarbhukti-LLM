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

dead_zone2 is a linear transfer function which follows a linear function except for x is close to 0.
Y = X if abs(x) > L otherwise its 0.

(*@KEY@:END_DESCRIPTION*)
FUNCTION DEAD_ZONE:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	L :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEAD_ZONE
IEC_LANGUAGE: ST
*)
IF ABS(x) > L THEN
	dead_zone := X;
ELSE
	DEAD_ZONE := 0.0;
END_IF;

(* revision history
hm	12. feb. 2007	rev 1.0
	original version

hm	14. jun. 2008	rev 1.1
	improved performance

hm	11. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
