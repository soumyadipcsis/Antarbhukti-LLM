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

TN_SC_XY2_ERROR prüft ob die angegenene Koordinaten die einen rechteckigen Bereich angeben gültig sind 

(*@KEY@:END_DESCRIPTION*)
FUNCTION TN_SC_XY2_ERROR:BOOL

(*Group:Default*)


VAR_INPUT
	X1 :	INT;
	Y1 :	INT;
	X2 :	INT;
	Y2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TN_SC_XY2_ERROR
IEC_LANGUAGE: ST
*)
(* min und max werte prüfen *)
TN_SC_XY2_ERROR := Y1 < 0 OR X1 < 0 OR Y2 < 0 OR X2 < 0 OR Y1 > 23 OR X1 > 79 OR Y2 > 23 OR X2 > 79;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
