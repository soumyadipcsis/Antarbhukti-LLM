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
tested by	tobias

this function calculates the arcus cotangens hyperbolicus

(*@KEY@:END_DESCRIPTION*)
FUNCTION ACOTH:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ACOTH
IEC_LANGUAGE: ST
*)
ACOTH := LN((x+1.0)/(x-1.0))*0.5;

(* revision history
hm		12 jan 2007	rev 1.0
	original version

hm		5. jan 2008	rev 1.1
	improved code for better performance

hm	10. mar. 2009		rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
