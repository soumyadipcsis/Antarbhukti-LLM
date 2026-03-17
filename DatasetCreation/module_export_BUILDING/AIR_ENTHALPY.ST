(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.0	31 oct 2007
programmer 	hugo
tested by	tobias

this function calculates the enthalpy for humid air between 0 and 100 deg C
(*@KEY@:END_DESCRIPTION*)
FUNCTION AIR_ENTHALPY:REAL

(*Group:Default*)


VAR_INPUT
	T :	REAL;
	RH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AIR_ENTHALPY
IEC_LANGUAGE: ST
*)
Air_enthalpy := 1.00482 * T + (1.86 * T + 2500.78) * dew_con(RH,T);

(* revision history

hm	31.10.2007		rev 1.0
	original version

hm	2.11.2007		rev 1.1
	deleted unused variable RF

hm	2.12.2007		rev 1.2
	changed code for better performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
