(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	15. jul. 2008
programmer 	hugo
tested by	oscat

JULIAN calculates the astronomic julian date from 1.1.2000-12:00.

(*@KEY@:END_DESCRIPTION*)
FUNCTION JD2000:REAL

(*Group:Default*)


VAR_INPUT
	DTI :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: JD2000
IEC_LANGUAGE: ST
*)
JD2000 := UDINT_TO_REAL(DTI - UDINT#946728000) / 86400.0;

(* revision histroy
hm	15. jul. 2008	rev 1.0
	original release
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
