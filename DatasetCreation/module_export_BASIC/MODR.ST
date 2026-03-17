(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.5	10. mar. 2009
programmer 	hugo
tested by	tobias

this is a modulo funtion for real numbers
modr(5.5,2.5) = 0.5

(*@KEY@:END_DESCRIPTION*)
FUNCTION MODR:REAL

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	DIVI :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MODR
IEC_LANGUAGE: ST
*)
IF divi = 0.0 THEN
	MODR := 0.0;
ELSE
	MODR := in - DINT_TO_REAL(FLOOR2(in / divi)) * divi;
END_IF;

(* revision history

hm	4. aug.2006		rev 1.0

hm	28. jan.2007	rev 1.1
	modr(x,0) will deliver the result 0

hm	21. mar 2008	rev 1.2
	use D_trunc for compatibility reasons

hm	4. apr. 2008	rev 1.3
	added type conversion to avoid warnings under codesys 3.0

hm	31. oct. 2008	rev 1.4
	changed algorithm to the more common version using floor instead of TRUNC

hm	10. mar. 2009	rev 1.5
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
