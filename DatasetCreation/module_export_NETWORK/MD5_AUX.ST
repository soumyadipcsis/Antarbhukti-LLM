(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.0	06. dec. 2009
programmer 	ks
tested by	ks

MD5_AUX ist ein Zusatzbaustein für MD5_STREAM und enthält wiederkehrende Berechnungen
 
(*@KEY@:END_DESCRIPTION*)
FUNCTION MD5_AUX:DWORD

(*Group:Default*)


VAR_INPUT
	N :	INT;
	A :	DWORD;
	B :	DWORD;
	C :	DWORD;
	D :	DWORD;
	X :	DWORD;
	U :	INT;
	T :	DWORD;
END_VAR


VAR
	w :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: MD5_AUX
IEC_LANGUAGE: ST
*)
CASE N OF
	1: w := (B AND C) OR (NOT(B) AND D);
	2: w := (B AND D) OR (C AND NOT D);
	3: w := (B XOR C XOR D);
	4: w := (C XOR (B OR  NOT(D)));
END_CASE;

(* MD5_AUX := B + ROL(A + w + X + T,U) *)
MD5_AUX := UDINT_TO_DWORD(DWORD_TO_UDINT(B) + DWORD_TO_UDINT(ROL_DWORD(UDINT_TO_DWORD(DWORD_TO_UDINT(A) + DWORD_TO_UDINT(w) + DWORD_TO_UDINT(X) + DWORD_TO_UDINT(T)),U)));

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
