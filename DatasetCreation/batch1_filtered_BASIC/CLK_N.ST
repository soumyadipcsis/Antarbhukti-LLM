(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	17 sep 2007
programmer 	hugo
tested by	tobias

clk_N uses the internal sps time to generate one pulse every N ms
every pulse is only valid for one cycle so that a edge trigger is not necessary
clk_gen generates pulses depending on the accuracy of the system clock.
The input N controlls the period time of the clock.
N=0 equals 2ms, N=1 equals 4ms, N=2 equals 8ms, N=3 equals 16ms ....

be careful, 1ms clocks will only work on very powerful sps cpu's
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CLK_N

(*Group:Default*)


VAR_INPUT
	N :	INT;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	T_PLC_MS :	T_PLC_MS;
	edge :	BOOL;
	clk :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CLK_N
IEC_LANGUAGE: ST
*)
T_PLC_MS();
clk := BIT_OF_DWORD(SHR(UDINT_TO_DWORD(T_PLC_MS.T_PLC_MS),N),0);
Q := clk XOR edge;
edge := clk;

(* revision history
hm	16. dec 2007		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
