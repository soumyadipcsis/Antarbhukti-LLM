(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.4	23 feb 2008
programmer 	oscat
tested by	tobias

this module conditions an internal real value for D/A converter.
Aout converts and internal real value to a word for an D/A converter or other output devices.
The input value is converted to a n-bit wide output and a sign bit is set separately as specified.
the outout min value is set for the specified min input value and the max output is set for the max input value.
an input higher or lower then the max or min value will set the respective max or min value or the output.
in value or the output.
(*@KEY@:END_DESCRIPTION*)
FUNCTION AOUT:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	BITS :	BYTE;
	SIGN :	BYTE;
	LOW :	REAL;
	HIGH :	REAL;
END_VAR


VAR
	in2 :	REAL;
	sx :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AOUT
IEC_LANGUAGE: ST
*)
(* if sign bit is defined *)
IF sign < BYTE#32 THEN
	sx := sign_R(in);
	in2 := ABS(in);
ELSE
	in2 := in;
END_IF;

(* begrenze in auf die zulässigen werte *)
in2 := LIMIT(low, in2, high);

(* Berechne den Ausgangswert *)
Aout := _REAL_TO_DWORD((in2 - low) / (high - low) * (_DWORD_TO_REAL(SHL(DWORD#2#1,_BYTE_TO_INT(bits))) - 1.0)   );
IF sx THEN Aout := SHL_DWORD(DWORD#2#1,_BYTE_TO_INT(sign)) OR Aout; END_IF;

(*
revision history

hm 18.1.2007		rev 1.1
	renamed Modul to aout.
	changed Output to 32 Bit max.
	corrected error with sign bit.

hm	13.9.2007		rev 1.2
	changed code to avoid warning under codesys 2.8.1

hm	2. dec 2007		rev 1.3
	changed code for better performance

hm	23. feb 2008	rev 1.4
	changed code for better performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
