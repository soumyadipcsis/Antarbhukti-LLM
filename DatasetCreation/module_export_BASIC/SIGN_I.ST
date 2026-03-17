(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	27. oct. 2008
programmer 	hugo
tested by	tobias

this function return true if the integer input is negative
(*@KEY@:END_DESCRIPTION*)
FUNCTION SIGN_I:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	DINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SIGN_I
IEC_LANGUAGE: ST
*)
sign_I := BIT_OF_DWORD(DINT_TO_DWORD(in),31);

(* revision history
hm 3.3.2007	rev 1.1
	changed method of function for better compatibility to other systems

hm	1.12.2007	rev 1.2
	changed code to improve performance

hm	27. oct. 2008	rev 1.3
	changed type of input to dint
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
