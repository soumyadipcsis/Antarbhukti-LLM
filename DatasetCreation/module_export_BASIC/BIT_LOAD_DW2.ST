(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0 18. oct. 2008
programmer 	hugo
tested by	tobias

this function loads N bits of D at pos P in DWORD I
(*@KEY@:END_DESCRIPTION*)
FUNCTION BIT_LOAD_DW2:DWORD

(*Group:Default*)


VAR_INPUT
	I :	DWORD;
	D :	BOOL;
	P :	INT;
	N :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIT_LOAD_DW2
IEC_LANGUAGE: ST
*)
IF D THEN
	BIT_LOAD_DW2 := ROL(SHR(DWORD#16#FFFFFFFF, 32 - N) OR ROR(I, P), P);
ELSE
	BIT_LOAD_DW2 := ROL(SHL(DWORD#16#FFFFFFFF, N) AND ROR(I, P), P);
END_IF;

(* revision history
hm	18. oct. 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
