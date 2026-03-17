(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16. mar 2008
programmer 	hugo
tested by	tobias

this function loads a bit into a DWord at position pos.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BIT_LOAD_DW:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	VAL :	BOOL;
	POS :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIT_LOAD_DW
IEC_LANGUAGE: ST
*)
IF val THEN
	BIT_LOAD_DW := in OR SHL(DWORD#1,pos);
ELSE
	BIT_LOAD_DW := in AND (NOT SHL(DWORD#1,pos));
END_IF;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	16. mar 2008	rev 1.1
	change input bit to val for compatibility reasons
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
