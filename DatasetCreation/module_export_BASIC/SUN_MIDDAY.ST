(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	26. jan. 2011
programmer 	hugo
tested by	oscat

this FUNCTION calculates the time when the sun stand exactly south of a given location.
(*@KEY@:END_DESCRIPTION*)
FUNCTION SUN_MIDDAY:UDINT

(*Group:Default*)


VAR_INPUT
	LON :	REAL;
	UTC :	UDINT;
END_VAR


VAR
	T :	REAL;
	OFFSET :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SUN_MIDDAY
IEC_LANGUAGE: ST
*)
T := INT_TO_REAL(DAY_OF_YEAR(utc));
OFFSET := -0.1752 * SIN(0.033430 * T + 0.5474) - 0.1340 * SIN(0.018234 * T - 0.1939);
SUN_MIDDAY := HOUR_TO_TOD(12.0 - OFFSET - lon * 0.0666666666666);

(* revision history

hm	26. jan. 2011	rev 1.0
	initial release

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
