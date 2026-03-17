(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16. oct. 2008
programmer 	oscat
tested by	oscat

MUX_R2 is an analog Multiplexer.
one of 2 real inputs are selected and put through to out.
The Adress input A selects between 2 Real inputs IN0 and IN1, A=0 > In0, A=1 > in1.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MUX_R2:REAL

(*Group:Default*)


VAR_INPUT
	IN0 :	REAL;
	IN1 :	REAL;
	A :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MUX_R2
IEC_LANGUAGE: ST
*)
MUX_R2 := SEL(A, IN0, IN1);

(* revision history
hm	19. jan. 2007	rev 1.0
	original version

hm	16. oct. 2008	rev 1.1
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
