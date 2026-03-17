(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	18. oct. 2008
programmer 	hugo
tested by	tobias

this function calculates an integer pseudo random number
the random number will be in the range of low <= rdm2 <= high.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK RDM2

(*Group:Default*)


VAR_INPUT
	LAST :	INT;
	LOW :	INT;
	HIGH :	INT;
END_VAR


VAR_OUTPUT
	RDM2 :	INT;
END_VAR


VAR
	rdm :	rdm;
END_VAR


(*@KEY@: WORKSHEET
NAME: RDM2
IEC_LANGUAGE: ST
*)
rdm(last:=fract(INT_TO_REAL(last) * 3.14159265358979323846264338327950288));
RDM2 := TRUNC_INT(rdm.RDM * INT_TO_REAL(high - low + 1)) + low;

(* revision history
hm		29. feb 2008		rev 1.0
	original version

hm		18. oct. 2008		rev 1.1
	using math constants

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
