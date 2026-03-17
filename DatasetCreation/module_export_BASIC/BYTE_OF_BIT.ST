(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.1	 18. feb 2006
programmer 	hugo
tested by	tobias

this function creates a byte from 8 individual bits
(*@KEY@:END_DESCRIPTION*)
FUNCTION BYTE_OF_BIT:BYTE

(*Group:Default*)


VAR_INPUT
	B0 :	BOOL;
	B1 :	BOOL;
	B2 :	BOOL;
	B3 :	BOOL;
	B4 :	BOOL;
	B5 :	BOOL;
	B6 :	BOOL;
	B7 :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: BYTE_OF_BIT
IEC_LANGUAGE: ST
*)
Byte_of_bit := SHL_BYTE(SHL_BYTE(SHL_BYTE(SHL_BYTE(SHL_BYTE(SHL_BYTE(SHL_BYTE(BOOL_TO_BYTE(B7),1) OR BOOL_TO_BYTE(B6),1)
 OR BOOL_TO_BYTE(B5),1) OR BOOL_TO_BYTE(B4),1) OR BOOL_TO_BYTE(B3),1) OR BOOL_TO_BYTE(B2),1)
 OR BOOL_TO_BYTE(B1),1) OR BOOL_TO_BYTE(B0);

(* revision history

hm	4. aug 2006		rev 1.0
	original version

hm	18. feb. 2008	rev 1.1
	improved performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
