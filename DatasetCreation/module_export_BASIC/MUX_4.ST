(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.2	16. oct. 2008
programmer 	hugo
tested BY	oscat

quad input multiplexer
depending on the value of A0 and A1, one of the 4 inputs will be switched to the Output
(*@KEY@:END_DESCRIPTION*)
FUNCTION MUX_4:BOOL

(*Group:Default*)


VAR_INPUT
	D0 :	BOOL;
	D1 :	BOOL;
	D2 :	BOOL;
	D3 :	BOOL;
	A0 :	BOOL;
	A1 :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MUX_4
IEC_LANGUAGE: ST
*)
IF A1 THEN
	MUX_4 := SEL(A0, D2, D3);
ELSE
	MUX_4 := SEL(A0, D0, D1);
END_IF;


(*
revision history:
hm 	5.10.2006		rev 1.1
	rewritten to ST for better portability

hm	16. oct. 2008	rev 1.2
	improved performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
