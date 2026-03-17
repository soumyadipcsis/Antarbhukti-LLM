(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SENSOR
*)
(*@KEY@:DESCRIPTION*)
version 1.5	10. mar. 2009
programmer 	hugo
tested by	tobias

this function returns the temperature for a nickel sensor in a range from -60..+180 °C *)
(*@KEY@:END_DESCRIPTION*)
FUNCTION TEMP_NI:REAL

(*Group:Default*)


VAR_INPUT
	RES :	REAL;
	R0 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TEMP_NI
IEC_LANGUAGE: ST
*)
TEMP_NI := (SQRT(0.30085225 - 2.66E-3 * (R0 - Res)) - 0.5485) * 751.8796992;


(* revision history

hm 24.1.2007		rev 1.1
	deleted unused variable A, B, C

hm 10.9.2007		rev 1.2
	changed accuracy to 0.02 degrees to improove performace

hm 17. 12 2007	rev 1.3
	improovements for better performance and higher accuracy

hm	6. jan 2008	rev 1.4
	further performance improvement

hm	10. mar. 2009	rev 1.5
	removed nested comments

*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION
