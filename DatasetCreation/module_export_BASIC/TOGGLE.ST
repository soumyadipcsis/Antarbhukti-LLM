(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.1	30. oct. 2008
programmer 	hugo
tested by	oscat

toggle flip flop the output changes state with every rising edge of clk.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TOGGLE

(*Group:Default*)


VAR_INPUT
	CLK :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	edge :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TOGGLE
IEC_LANGUAGE: ST
*)
IF rst THEN
	Q := FALSE;
ELSIF clk AND NOT edge THEN
	Q := NOT Q;
END_IF;
edge := clk;

(* revision history

hm	13.9.2007		rev 1.0
	original version

hm	30. oct. 2008	rev 1.1
	deleted unnecessary init

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
