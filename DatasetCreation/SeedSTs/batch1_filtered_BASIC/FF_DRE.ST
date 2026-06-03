(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.2	30. oct. 2008
programmer 	hugo
tested by	oscat

D-type flip flop with set, reset and rising clock trigger
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FF_DRE

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	D :	BOOL;
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
NAME: FF_DRE
IEC_LANGUAGE: ST
*)
IF rst OR set THEN
	Q := NOT rst;
ELSIF clk AND NOT edge THEN
	Q := D;
END_IF;
edge := CLK;

(* revision history
hm	4. aug 2006		rev 1.0
	original version

hm	27. dec 2007	rev 1.1
	changed code for better performance

hm	30. oct. 2008	rev 1.2
	optimized performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
