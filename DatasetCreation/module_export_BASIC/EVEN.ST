(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	1 dec 2007
programmer 	hugo
tested by	tobias

this function chacks an input for even  value
the output is true if the input is even.
(*@KEY@:END_DESCRIPTION*)
FUNCTION EVEN:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	DINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: EVEN
IEC_LANGUAGE: ST
*)
even := NOT BIT_OF_DWORD(DINT_TO_DWORD(in),0);

(* revision history
hm	1. oct 2006	rev 1.0
	ORIGINAL VERSION

hm	01.12.2007	rev 1.1
	changed code for improved performance

hm	21. mar. 2008	rev 1.2
	changed type of input IN from INT to DINT
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
