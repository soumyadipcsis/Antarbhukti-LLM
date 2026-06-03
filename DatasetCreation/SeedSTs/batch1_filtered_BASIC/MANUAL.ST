(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21. nov. 2008
programmer 	hugo
tested by	oscat

MANUAL is a manual override for digital signals.
when on and off = FALSE, the output follows IN.
ON = TRUE forces the output high, and OFF = TRUE forces the output low.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MANUAL:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	ON :	BOOL;
	OFF :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MANUAL
IEC_LANGUAGE: ST
*)
MANUAL := NOT OFF AND (IN OR ON);



(* revision history
hm	21. nov 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
