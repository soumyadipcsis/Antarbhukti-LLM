(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	7. mar. 2009
programmer 	hugo
tested by	oscat

REFRACTION calculates the atmospheric refraction in degrees.
the input angle goes from 0 at the hirizon to 90 at midday.
(*@KEY@:END_DESCRIPTION*)
FUNCTION REFRACTION:REAL

(*Group:Default*)


VAR_INPUT
	ELEV :	REAL;
END_VAR


VAR
	tmp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: REFRACTION
IEC_LANGUAGE: ST
*)
tmp := LIMIT(-1.9, elev, 80.0);
REFRACTION := 0.0174532925199433 / TAN(0.0174532925199433 * (tmp + 10.3 / (tmp + 5.11)));

(* revision histroy
hm	14. jul. 2008	rev 1.0
	original release

hm	7. mar. 2009	rev 1.1
	using new formula

*)	

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
