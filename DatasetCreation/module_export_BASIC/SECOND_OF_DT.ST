(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	6. jun. 2008
programmer 	oscat
tested BY	oscat

SECOND_OF_DT returns the current second (second of minute) of a DT variable
(*@KEY@:END_DESCRIPTION*)
FUNCTION SECOND_OF_DT:INT

(*Group:Default*)


VAR_INPUT
	XDT :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SECOND_OF_DT
IEC_LANGUAGE: ST
*)
SECOND_OF_DT := UDINT_TO_INT(XDT MOD UDINT#60);

(* revision history
hm		6.9.2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
