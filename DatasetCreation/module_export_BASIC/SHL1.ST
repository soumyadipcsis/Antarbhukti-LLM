(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.1	27 dec 2007
programmer 	hugo
tested by	tobias

SHL1 shifts N bits to the left filling the new bits with 1
(*@KEY@:END_DESCRIPTION*)
FUNCTION SHL1:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	N :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SHL1
IEC_LANGUAGE: ST
*)
SHL1 := SHR(DWORD#16#FF_FF_FF_FF,32-N) OR SHL(IN,N);

(* revision history
hm	14.9.2007		rev 1.0
	original version

hm	27. dec 2007	rev 1.1
	changed code for better performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
