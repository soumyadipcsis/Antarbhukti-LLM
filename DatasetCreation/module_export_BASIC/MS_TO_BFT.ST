(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	12. jun 2008
programmer 	hugo
tested by	oscdat

this function converts wind speed from M/s to beaufort
(*@KEY@:END_DESCRIPTION*)
FUNCTION MS_TO_BFT:INT

(*Group:Default*)


VAR_INPUT
	MS :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MS_TO_BFT
IEC_LANGUAGE: ST
*)
MS_TO_BFT := REAL_TO_INT(EXPT(MS * 1.196172, 0.666667));


(* revision history
hm	12. 6. 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
