(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.5	16 mar 2008
programmer 	oscat
tested by	tobias

Ain converts signals from A/D converters or other digital sources to an internal real value
the lowest number of bits are extracted from the input word and the sign will be extracted if available separately.
the output signal is then conditioned to range from low to high values for a 0 to max value on the analog inputs:
for example a 15bit input (bits := 12) with sign at bit 15 (0..15) will deliver 0.0 (low value at 0) for an input value of 2#0000_0000_0000
an input value of 2#1111_1111_1111 will deliver 10.0 on the output (high value set to 10).
(*@KEY@:END_DESCRIPTION*)
FUNCTION AIN:REAL

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	BITS :	BYTE;
	SIGN :	BYTE;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


VAR
	temp1 :	DWORD;
	temp2 :	DWORD;
	sx :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AIN
IEC_LANGUAGE: ST
*)
(* extract the sign bit *)
IF sign < BYTE#32 THEN
	temp1 := SHR_DWORD(in, _BYTE_TO_INT(sign));
	sx := BIT_OF_DWORD(temp1,0); (* temp1.X0 *)
ELSE
	sx := FALSE;
END_IF;
temp1 := SHR_DWORD(DWORD#16#FFFFFFFF,32 - _BYTE_TO_INT(bits));
temp2 := in AND temp1;
AIN := (high - low)* _DWORD_TO_REAL(temp2) / _DWORD_TO_REAL(temp1) + low;
IF sx THEN AIN := -AIN; END_IF;

(* revision history
hm 18.8.2006	rev 1.1
	fixed an error with low value negative and high value 0.

hm 19.1.2007	rev 1.2
	fixed an error with sign bit.

hm	13.9.2007	rev 1.3
	changed code to avoid warning under codesys 2.8.1

hm	2. dec 2007	rev 1.4
	changed code for better performance

hm	16. mar 2008	rev 1.5
	added type conversions to avoid warnings under codesys 30
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
