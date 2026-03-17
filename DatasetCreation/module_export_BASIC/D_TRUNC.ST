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

d_trunc truncates a real to a dint 1.5 will be 1 and -1.5 will be -1
d_trunc is necessary because many systems do not offer a trunc to a dint
also real_to_dint will not deliver the same result on different systems

(*@KEY@:END_DESCRIPTION*)
FUNCTION D_TRUNC:DINT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: D_TRUNC
IEC_LANGUAGE: ST
*)
D_TRUNC := TRUNC_DINT(X);

(*
D_TRUNC := REAL_TO_DINT(X);
IF X > 0.0 THEN
	IF DINT_TO_REAL(D_TRUNC) > X THEN D_TRUNC := D_TRUNC - DINT#1; END_IF;
ELSE
	IF DINT_TO_REAL(D_TRUNC) < X THEN D_TRUNC := D_TRUNC + DINT#1; END_IF;
END_IF;
*)

(* for systems that support a dint truncation this routine can be replaced by trunc() *)


(* revision history
hm	21. mar. 2008	rev 1.0
	original version

hm	31. oct. 2008	rev 1.1
	optimized performance

hm	10. mar. 2009	rev 1.2
	real constants updated to new systax using dot
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
