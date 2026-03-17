(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. jan. 2011
programmer 	hugo
tested by	tobias

Scale_B is used to translate and scale a byte input x to a real output.


(*@KEY@:END_DESCRIPTION*)
FUNCTION SCALE_B:REAL

(*Group:Default*)


VAR_INPUT
	X :	BYTE;
	I_LO :	BYTE;
	I_HI :	BYTE;
	O_LO :	REAL;
	O_HI :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SCALE_B
IEC_LANGUAGE: ST
*)
IF I_HI = I_LO THEN
	SCALE_B := O_LO;
ELSE
	SCALE_B := (O_HI - O_LO) / USINT_TO_REAL(BYTE_TO_USINT(I_HI) - BYTE_TO_USINT(I_LO)) * _BYTE_TO_REAL(LIMIT(I_LO,X,I_HI));
END_IF;

(* revision history
hm	18. may. 2008		rev 1.0
	original version

hm	18. jan 2011		rev 1.1
	avoid division by 0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
