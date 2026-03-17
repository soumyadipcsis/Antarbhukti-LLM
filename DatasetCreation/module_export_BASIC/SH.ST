(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16 jan 2007
programmer 	hugo
tested by	tobias

this sample and hold module samples an input at the rising edge of clk an stores it in out.
the out stays stable until the next rising clk edge appears.
a trigger output as active for one cycle when the output was updated.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SH

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	CLK :	BOOL;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
	TRIG :	BOOL;
END_VAR


VAR
	edge :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SH
IEC_LANGUAGE: ST
*)
IF clk AND NOT edge THEN
	out := in;
	trig := TRUE;
ELSE;
	trig := FALSE;
END_IF;
edge := clk;

(* revision history

hm 16.1.2007	rev 1.1
	added trig output

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
