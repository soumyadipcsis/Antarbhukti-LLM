(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.3	13. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the air density between 0 and 100 deg C
(*@KEY@:END_DESCRIPTION*)
FUNCTION AIR_DENSITY:REAL

(*Group:Default*)


VAR_INPUT
	T :	REAL;
	P :	REAL;
	RH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AIR_DENSITY
IEC_LANGUAGE: ST
*)
AIR_DENSITY := 101325.0 * (1.0 - RH * SDD(T, TRUE) * 3.773319E-3 / P) / (287.05 * ( T - -273.15));

(* original code used for rev 1.0

SDD := SDD(T,FALSE);
RF := RL / (1- RH*SDD/P*RX);
Air_density := P / (RF * (T-TK));

*)

(* revision history

hm	29.10.2007	rev 1.0
	original version

hm	4.12.2007		rev 1.1
	changed code for better performance

hm	18. oct. 2008	rev 1.2
	using phys constants

hm	13. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
