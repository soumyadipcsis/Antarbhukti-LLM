(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.1	30. jun. 2008
programmer 	hugo
tested by	tobias

this function converts a two digit bcd number into an integer.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BCDC_TO_INT:INT

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: BCDC_TO_INT
IEC_LANGUAGE: ST
*)
BCDC_TO_INT := _BYTE_TO_INT(in AND BYTE#16#0F) + (_BYTE_TO_INT(SHR(in,4)) * 10);

(* revision history
hm	13.12.2007		rev 1.0
	original version

hm	30. jun. 2008	rev 1.1
	changed name to avoid collision with util.lib
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
