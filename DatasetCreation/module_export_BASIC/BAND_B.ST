(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21. Nov. 2008
programmer 	hugo
tested by	oscat

BAND_B will limit X to B <= X <= 255-B. while X < B the resulkt will be 0 and while X > 255-B the output will be 255
otherwise the result = X.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BAND_B:BYTE

(*Group:Default*)


VAR_INPUT
	X :	BYTE;
	B :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: BAND_B
IEC_LANGUAGE: ST
*)
IF X < B THEN
	BAND_B := BYTE#0;
ELSIF X > USINT_TO_BYTE(USINT#255 - BYTE_TO_USINT(B)) THEN
	BAND_B := BYTE#255;
ELSE
	BAND_B := X;
END_IF;



(* revision history
hm	21. nov. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
