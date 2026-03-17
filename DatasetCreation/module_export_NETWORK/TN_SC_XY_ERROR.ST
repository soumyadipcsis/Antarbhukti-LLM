(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TELNET_VISION
*)
(*@KEY@:DESCRIPTION*)
version 1.0		10. mai 2010
programmer		ks
tested by		ks

TN_SC_XY_ERROR prüft ob die angegenene Koordinaten gültig sind 

(*@KEY@:END_DESCRIPTION*)
FUNCTION TN_SC_XY_ERROR:BOOL

(*Group:Default*)


VAR_INPUT
	X :	INT;
	Y :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TN_SC_XY_ERROR
IEC_LANGUAGE: ST
*)
(* min und max werte prüfen *)
TN_SC_XY_ERROR := Y < 0 OR X < 0 OR Y > 23 OR X > 79;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
