(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0	23 feb 2008
programmer 	oscat
tested by	tobias

this module conditions an internal real value for a D/A converter.
(*@KEY@:END_DESCRIPTION*)
FUNCTION AOUT1:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	BIT_0 :	INT;
	BIT_N :	INT;
	SIGN :	INT;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


VAR
	in2 :	REAL;
	sx :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AOUT1
IEC_LANGUAGE: ST
*)
(* if sign bit is defined *)

IF sign < 32 THEN
	sx := sign_R(in);
	in2 := ABS(in);
ELSE
    sx := FALSE;
	in2 := in;
END_IF;

(* begrenze in auf die zulässigen werte *)
in2 := LIMIT_REAL(low, in2, high);

(* Berechne den Ausgangswert *)
AOUT1 :=  SHL_DWORD(_REAL_TO_DWORD((in2 - low) / (high - low) * UDINT_TO_REAL(DWORD_TO_UDINT(SHL(DWORD#2#1,bit_n - Bit_0 + 1)) - UDINT#1)),Bit_0);

IF sx THEN AOUT1 := SHL(DWORD#2#1,sign) OR AOUT1; END_IF;

(* revision history
hm	23. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
