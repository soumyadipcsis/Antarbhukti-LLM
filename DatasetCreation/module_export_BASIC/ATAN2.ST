(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. mar. 2009
programmer 	hugo
tested by	oscat

this function calculates the angle in a coordinate system in rad.
(*@KEY@:END_DESCRIPTION*)
FUNCTION ATAN2:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	Y :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ATAN2
IEC_LANGUAGE: ST
*)
IF X > 0.0 THEN
	ATAN2 := ATAN(Y/X);
ELSIF X < 0.0 THEN
	IF Y >= 0.0 THEN
		ATAN2 := ATAN(Y/X) + 3.14159265358979323846264338327950288;
	ELSE
		ATAN2 := ATAN(Y/X) - 3.14159265358979323846264338327950288;
	END_IF;
ELSIF Y > 0.0 THEN
	ATAN2 := 1.5707963267948965580;
ELSIF Y < 0.0 THEN
	ATAN2 := -1.5707963267948965580;
ELSE
	ATAN2 := 0.0;
END_IF;


(* revision history
hm	20.  apr. 2008	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	changed to use math constants

hm	10. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
