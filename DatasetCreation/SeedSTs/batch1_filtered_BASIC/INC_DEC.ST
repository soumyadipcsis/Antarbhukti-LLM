(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	4 aug 2006
programmer 	oscat
tested BY	oscat

incremental decoder with quadruple accuracy.
2 pulses for each channel are created for each directional pulse.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK INC_DEC

(*Group:Default*)


VAR_INPUT
	CHA :	BOOL;
	CHB :	BOOL;
	RST :	BOOL := 0;
END_VAR


VAR_OUTPUT
	DIR :	BOOL;
	CNT :	INT;
END_VAR


VAR
	edgea :	BOOL := 0;
	clk :	BOOL;
	clka :	BOOL;
	clkb :	BOOL;
	edgeb :	BOOL;
	axb :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: INC_DEC
IEC_LANGUAGE: ST
*)
axb := cha XOR chb;

(* create pulses for channel a *)
clka := cha XOR edgea;
edgea := cha;

clkb := chb XOR edgeb;
edgeb := chb;

(* create pulses for both channels *)
clk := clka OR clkb;

(* set the direction output *)
IF axb AND clka THEN dir := TRUE; END_IF;
IF axb AND clkb THEN dir := FALSE; END_IF;

(* increment or decrement the counter *)
IF clk AND dir THEN cnt := cnt + 1; END_IF;
IF clk AND NOT dir THEN cnt := cnt -1; END_IF;

(* reset the counter if rst active *)
IF rst THEN cnt := 0; END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
