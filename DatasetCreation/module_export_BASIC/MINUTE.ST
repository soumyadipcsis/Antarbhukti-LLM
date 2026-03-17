(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	2 oct 2006
programmer 	hugo
tested by	tobias

extracts the minutes out of TOD truncating the ceconds
(*@KEY@:END_DESCRIPTION*)
FUNCTION MINUTE:INT

(*Group:Default*)


VAR_INPUT
	ITOD :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MINUTE
IEC_LANGUAGE: ST
*)
minute := UDINT_TO_INT((itod / UDINT#60000) - ((itod / UDINT#3600000) * UDINT#60));

(* change history

2.10.2006 changes name of input to itod

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
