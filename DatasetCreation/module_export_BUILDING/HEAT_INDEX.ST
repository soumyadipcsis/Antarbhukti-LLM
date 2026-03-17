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

this function calculates the heat index temperature depending on external temperature and Relative humidity
(*@KEY@:END_DESCRIPTION*)
FUNCTION HEAT_INDEX:REAL

(*Group:Default*)


VAR_INPUT
	T :	REAL;
	RH :	REAL;
END_VAR


VAR
	RH2 :	REAL;
	T2 :	REAL;
	TX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HEAT_INDEX
IEC_LANGUAGE: ST
*)
IF RH < 20.0 OR T < 20.0 THEN
	HEAT_INDEX := T;
ELSE
	TX := T;
	RH2 := RH * RH;
	TX := C_TO_F(TX);
	T2 := TX * TX;
	HEAT_INDEX := -42.379 + 2.04901523 * TX - 6.83783E-3 * T2
			+ RH * (10.1433127 - 0.22475541 * TX + 1.22874E-3 * T2)
			+ RH2 * (8.5282E-4 * TX - 5.481717E-2 - 1.99E-6 * T2);
	HEAT_INDEX := F_TO_C(HEAT_INDEX);
END_IF;

(* revision history

hm 27.2.2007		rev 1.1
	deleted unused variables rh3 and T3

hm	2.12.2007		rev 1.2
	changed code for better performance

hm	13. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
