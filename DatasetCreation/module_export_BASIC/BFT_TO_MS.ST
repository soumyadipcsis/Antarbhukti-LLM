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

this function converts wind speed from beaufort to m/s
(*@KEY@:END_DESCRIPTION*)
FUNCTION BFT_TO_MS:REAL

(*Group:Default*)


VAR_INPUT
	BFT :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BFT_TO_MS
IEC_LANGUAGE: ST
*)
BFT_TO_MS := EXPT(INT_TO_REAL(BFT), 1.5) * 0.836;


(* revision history
hm	12. 6. 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
