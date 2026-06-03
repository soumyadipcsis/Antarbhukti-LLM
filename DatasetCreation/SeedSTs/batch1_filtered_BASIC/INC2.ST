(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	29. jun. 2008
programmer 	hugo
tested by	oscat

This function increments the input X by the value D and compares the result with U.
if the output exceeds U it will continue to count from L again.
(*@KEY@:END_DESCRIPTION*)
FUNCTION INC2:INT

(*Group:Default*)


VAR_INPUT
	X :	INT;
	D :	INT;
	L :	INT;
	U :	INT;
END_VAR


VAR
	tmp :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: INC2
IEC_LANGUAGE: ST
*)
tmp := U - L + 1;
INC2 := (X + D - L + tmp) MOD tmp + L;

(* revision history
hm	29. jun. 2008		REV 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
