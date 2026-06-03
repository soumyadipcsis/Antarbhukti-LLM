(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	15. jan 2008
programmer 	hugo
tested by	tobias

This is a increment function which increments the input X by the value D and compares the result with M.
if the output exceeds M it will continue to count from 0 again.
(*@KEY@:END_DESCRIPTION*)
FUNCTION INC:INT

(*Group:Default*)


VAR_INPUT
	X :	INT;
	D :	INT;
	M :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: INC
IEC_LANGUAGE: ST
*)
inc := (X + D + M + 1) MOD (M + 1);

(* revision history
hm	7. feb 2007		REV 1.0
	original version

hm	15. jan 2008	rev 1.1
	allow for neagtive increment

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
