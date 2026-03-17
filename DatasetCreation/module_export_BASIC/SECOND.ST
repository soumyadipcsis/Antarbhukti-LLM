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

returns the seconds and milliseconds as real of TOD
(*@KEY@:END_DESCRIPTION*)
FUNCTION SECOND:REAL

(*Group:Default*)


VAR_INPUT
	ITOD :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SECOND
IEC_LANGUAGE: ST
*)
(*
second := UDINT_TO_REAL(itod - itod/UDINT#60000 * UDINT#60000) / 1000.0;
*)


second := UDINT_TO_REAL(itod MOD UDINT#60000) / REAL#1000.00;




(* change history

2.10.2006 changes name of input to itod

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
