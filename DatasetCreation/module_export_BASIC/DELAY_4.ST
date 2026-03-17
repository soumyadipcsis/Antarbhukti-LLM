(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.1	19 jan 2007
programmer 	hugo
tested by	tobias

this function block delays input values by each programm cycle
after 4 cycles the in value has shifted to the out 4 and will be discarded after the next cycle
the blocks can be cascaded.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DELAY_4

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
END_VAR


VAR_OUTPUT
	OUT1 :	REAL;
	OUT2 :	REAL;
	OUT3 :	REAL;
	OUT4 :	REAL;
END_VAR


VAR
	temp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DELAY_4
IEC_LANGUAGE: ST
*)
out4 := out3;
out3 := out2;
out2 := out1;
out1 := temp;
temp := in;

(* revision history

hm 19.1.2007	rev 1.1
	added variable temp to add 1 delay  for q1

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
