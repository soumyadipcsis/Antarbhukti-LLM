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

TN_SC_SHADOW_ATTR berechnet aus einem normalen einem abgedunkelten Farbcode

(*@KEY@:END_DESCRIPTION*)
FUNCTION TN_SC_SHADOW_ATTR:BYTE

(*Group:IN_OUT*)


VAR_INPUT
	Iby_ATTR :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
(* Background Farbe auf Schwarz ändern      *)
(* und dunkle Fordergrundfarben einschalten *)  
TN_SC_SHADOW_ATTR := ((Iby_ATTR AND BYTE#2#11110000) OR BYTE#2#00001000);

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
