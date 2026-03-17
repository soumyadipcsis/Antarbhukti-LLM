(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10 sep 2007
programmer 	hugo
tested by	tobias

BIT_COUNT counts the amount True of bits in a dword.
for exabple: bit_count(3) returns 2 because two bits (bits 0 and 1) are true and all others are false.
(*@KEY@:END_DESCRIPTION*)
FUNCTION BIT_COUNT:INT

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
END_VAR


VAR
	in_temp :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: BIT_COUNT
IEC_LANGUAGE: ST
*)
in_temp := IN;
WHILE in_temp > DWORD#0 DO
	IF (in_temp AND DWORD#16#00000001) > DWORD#0 THEN Bit_Count := Bit_Count +1; END_IF;
	in_temp := SHR(in_temp,1);
END_WHILE;

(* revision history
5.7.2007	rev 1.0		original version

10.9.2007	rev 1.1		hm
	changed algorithm for better performace
	the execution time has reduced by a factor of 5
	deleted unused variable temp
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
