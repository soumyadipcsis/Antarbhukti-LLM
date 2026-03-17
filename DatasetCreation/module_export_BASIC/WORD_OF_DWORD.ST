(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.2	30. oct. 2008
programmer 	hugo
tested by	oscat

this function extracts a single word from the nth position from right (right is lowest byte)
the lower word (starting with Bit0 from in) is selected with N=0.
(*@KEY@:END_DESCRIPTION*)
FUNCTION WORD_OF_DWORD:WORD

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	N :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: WORD_OF_DWORD
IEC_LANGUAGE: ST
*)
WORD_OF_DWORD := DWORD_TO_WORD(SHR(in,_BYTE_TO_INT(SHL(n,4))));

(* revision history
hm	17. jan 2007	rev 1.0
	original version

hm	2. jan 2008		rev 1.1
	improved performance

hm	30. oct. 2008	rev 1.2
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
