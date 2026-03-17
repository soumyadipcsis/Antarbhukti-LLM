(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	tobias

this function converts frequency to periode time  
(*@KEY@:END_DESCRIPTION*)
FUNCTION F_TO_PT:TIME

(*Group:Default*)


VAR_INPUT
	F :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_TO_PT
IEC_LANGUAGE: ST
*)
F_TO_PT := DWORD_TO_TIME(_REAL_TO_DWORD(1.0 / F * 1000.0));


(* revision history

hm	4. aug. 2006	rev 1.0
	original version

hm	11. mar. 2009	rev 1.1
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
