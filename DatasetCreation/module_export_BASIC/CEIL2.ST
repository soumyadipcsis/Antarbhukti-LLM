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

This is a rounding function which returns the smallest possible integer which is greater or equal to X.
ceil2(3.14) = 4
ceil2(-3.14) = -3

(*@KEY@:END_DESCRIPTION*)
FUNCTION CEIL2:DINT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CEIL2
IEC_LANGUAGE: ST
*)
CEIL2 := _REAL_TO_DINT(x);
IF DINT_TO_REAL(CEIL2) < X THEN
        CEIL2 := CEIL2 + DINT#1;
END_IF;


(* revision history
hm	21. mar. 2008	rev 1.0
	original version

hm	4. apr. 2008	rev 1.1
	added type conversion to avoid warnings under codesys 3.0

hm	30. jun. 2008	rev 1.2
	added type conversion to avoid warnings under codesys 3.0

hm	10. mar. 2009	rev 1.3
	use correct statement real_to_DINT

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
