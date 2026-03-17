(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.2	6. jun. 2008
programmer 	hugo
tested by	tobias

this function extracts a single bit from the nth position from right (right is lowest bit)
the lowest Bit (Bit0 from in) is selected with N=0.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BIT_OF_DWORD:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	N :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIT_OF_DWORD
IEC_LANGUAGE: ST
*)
BIT_OF_DWORD := (SHR_DWORD(in,n) AND DWORD#1) > DWORD#0;

(* old code used before rev 1.1
temp := SHR(in,n);
Bit_of_Dword := temp.0;
*)

(* revision history
hm	4. aug. 2006	rev 1.0
	original version

hm	29. feb 2008	rev 1.1
	improved performance

hm	6. jun. 2008	rev 1.2
	changes type of input N from byte to int
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
