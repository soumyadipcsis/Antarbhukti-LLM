(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	hugo
tested by	tobias

this function returns the fraction of a real number
fract(3.14) = 0.14

(*@KEY@:END_DESCRIPTION*)
FUNCTION FRACT:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FRACT
IEC_LANGUAGE: ST
*)
IF ABS(x) < 2.0E9 THEN
	FRACT := x - DINT_TO_REAL(D_TRUNC(x));
ELSE
	FRACT := 0.0;
END_IF;

(* revision history
hm	4. aug 2006	rev 1.0
	original version

hm	11. mar 2008	rev 1.1
	added dint_to_real for compatibility reasons
	now returns 0 for number > 2e9
	changed input to x

hm	21. mar. 2008	rev 1.2
	use D_trunc instead of TRUNC for compatibility reasons

hm	10. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
