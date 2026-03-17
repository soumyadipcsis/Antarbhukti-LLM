(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	tobias

MIX is an analog Mixer. The Output is (1-M)*A + M*B.

(*@KEY@:END_DESCRIPTION*)
FUNCTION MIX:REAL

(*Group:Default*)


VAR_INPUT
	A :	REAL;
	B :	REAL;
	M :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MIX
IEC_LANGUAGE: ST
*)
MIX := (1.0 - M) * A + M * B;

(* revision history
hm	19. Nov 2007	rev 1.0
	original version

hm	10. mar 2009	rev 1.1
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
