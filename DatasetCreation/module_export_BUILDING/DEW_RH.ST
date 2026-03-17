(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.2	13. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the relative humidity in air for a given temperature in °C and vapor concentration in Kg/m³..
(*@KEY@:END_DESCRIPTION*)
FUNCTION DEW_RH:REAL

(*Group:Default*)


VAR_INPUT
	VC :	REAL;
	T :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEW_RH
IEC_LANGUAGE: ST
*)
DEW_RH := LIMIT(0.0, VC / DEW_CON(1.0, T), 100.0);

(* code before rev 1.1
dew_rh := VC / dew_con(100,T) * 100;
IF dew_rh > 100 THEN dew_rh := 100; END_IF;
*)

(* revision history
hm	29. apr 2007	rev 1.0
	original version

hm	2. 12. 2007	rev 1.1
	new code for better performance

hm	13. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
