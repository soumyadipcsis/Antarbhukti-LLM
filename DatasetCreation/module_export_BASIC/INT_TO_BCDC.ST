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

this function converts an integer into a two digit bcd number.
(*@KEY@:END_DESCRIPTION*)
FUNCTION INT_TO_BCDC:BYTE

(*Group:Default*)


VAR_INPUT
	IN :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: INT_TO_BCDC
IEC_LANGUAGE: ST
*)
INT_TO_BCDC := SHL_BYTE(INT_TO_BYTE(IN / INT#10),4) OR INT_TO_BYTE(in MOD INT#10);

(* revision history
hm	13.12.2007
	original version

hm	30.6.2008	rev 1.1
	changed name INT_TO_BCD to INT_TO_BCDC to avoid collision with util.lib
	corrected error in code

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
