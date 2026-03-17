(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	14 mar 2008
programmer 	hugo
tested by	tobias

multiplies a time by a real number and returns a time
(*@KEY@:END_DESCRIPTION*)
FUNCTION MULTIME:TIME

(*Group:Default*)


VAR_INPUT
	T :	TIME;
	M :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MULTIME
IEC_LANGUAGE: ST
*)
multime := DWORD_TO_TIME(_REAL_TO_DWORD(_DWORD_TO_REAL(TIME_TO_DWORD(t))*M));

(* revision history
hm		2. oct 2006	rev 1.0
	original version

hm		14. mar 2008	rev 1.1
	rounded the result after the last digit

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
