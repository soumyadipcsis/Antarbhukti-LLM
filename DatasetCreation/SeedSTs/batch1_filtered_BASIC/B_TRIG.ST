(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	4 aug 2006
programmer 	hugo
tested by	tobias

this block is similar to R_trig and F_trig but it generates a pulse on rising and falling edge.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK B_TRIG

(*Group:Default*)


VAR_INPUT
	CLK :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL := FALSE;
END_VAR


VAR
	edge :	BOOL := FALSE;
END_VAR


(*@KEY@: WORKSHEET
NAME: B_TRIG
IEC_LANGUAGE: ST
*)
Q := clk XOR edge;
edge := CLK;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
