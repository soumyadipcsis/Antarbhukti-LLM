(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. mar. 2009
programmer 	hugo
tested by	oscat

this function calculates X to the power of N (Y = X^N) whilke N is an integer
especially on CPU's without a floating point unit this algorythm is about 30 times faster then the IEC standard EXPT() Function

(*@KEY@:END_DESCRIPTION*)
FUNCTION EXPN:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	N :	INT;
END_VAR


VAR
	N_word :	WORD;
	X_tmp :	REAL;
	sign :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: EXPN
IEC_LANGUAGE: ST
*)
N_word := INT_TO_WORD(N);
X_tmp := X;
sign := BIT_OF_DWORD(WORD_TO_DWORD(N_word),15);
N_word := INT_TO_WORD(ABS(N));
IF BIT_OF_DWORD(WORD_TO_DWORD(N_word),0) THEN expn := X_tmp; ELSE expn := 1.0; END_IF;    (* N_word.X0 *)
N_word := SHR(N_word,1);
WHILE N_word > WORD#0 DO
	X_tmp := X_tmp * X_tmp;
	IF BIT_OF_DWORD(WORD_TO_DWORD(N_word),0) THEN expn := expn * X_tmp; END_IF;       (* N_word.X0 *)
	N_word := SHR(N_word,1);
END_WHILE;
IF sign THEN EXPN := 1.0 / EXPN; END_IF;

(* revision history
hm	4. dec 2007	rev 1.0
	original version

hm	22. oct. 2008	rev 1.1
	optimized code

hm	10. mar. 2009	rev 1.2
	removed nested comments
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
