(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0	16. jan 2011
programmer 	hugo
tested BY	tobias

This function reverses the specified amount of bits from bit 0 to bit n within a dword  while L specifies the amount of Bits to be reflected.

(*@KEY@:END_DESCRIPTION*)
FUNCTION REFLECT:DWORD

(*Group:Default*)


VAR_INPUT
	D :	DWORD;
	L :	INT;
END_VAR


VAR
	i :	INT;
	_d :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: REFLECT
IEC_LANGUAGE: ST
*)
REFLECT := DWORD#0;
_d := D;
FOR i := 1 TO L DO
	REFLECT := SHL(REFLECT, 1) OR BOOL_TO_DWORD((_d AND DWORD#2#0000_0001) > DWORD#0); (* D.0 *)
	_d := SHR(_d, 1);
END_FOR;
REFLECT := REFLECT OR SHL(_d, L);

(* revision history
hm	 16. jan 2011
	new module

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
