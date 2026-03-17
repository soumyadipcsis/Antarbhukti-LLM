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

this function loads N bits of D at pos P in Byte I
(*@KEY@:END_DESCRIPTION*)
FUNCTION BIT_LOAD_B2:BYTE

(*Group:Default*)


VAR_INPUT
	I :	BYTE;
	D :	BOOL;
	P :	INT;
	N :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIT_LOAD_B2
IEC_LANGUAGE: ST
*)
IF D THEN
	BIT_LOAD_B2 := ROL(SHR(BYTE#255, 8 - N) OR ROR(I, P), P);
ELSE
	BIT_LOAD_B2 := ROL(SHL(BYTE#255, N) AND ROR(I, P), P);
END_IF;

(* revision history
hm	18. oct. 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
