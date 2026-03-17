(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21 feb 2008
programmer 	hugo
tested by	oscat

this function converts different temperature units
any unused input can simply be left open.
different inputs connected at the same time will be added up.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TEMPERATURE

(*Group:Default*)


VAR_INPUT
	K :	REAL;
	C :	REAL := -273.15;
	F :	REAL := -459.67;
	RE :	REAL := -218.52;
	RA :	REAL := 0.0;
END_VAR


VAR_OUTPUT
	YK :	REAL;
	YC :	REAL;
	YF :	REAL;
	YRE :	REAL;
	YRA :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TEMPERATURE
IEC_LANGUAGE: ST
*)
YK := K + (C + 273.15) + (F + 459.67) * 0.555555555555 + (Re * 1.25 + 273.15) + (Ra * 0.555555555555);
YC := YK -273.15;
YF := YK * 1.8 - 459.67;
YRe := (YK - 273.15) * 0.8;
YRa := YK * 1.8;

(* revision history
hm	21. feb. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
