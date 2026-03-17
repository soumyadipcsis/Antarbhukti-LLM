(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	18. oct. 2008
programmer 	hugo
tested by	tobias

this function calculates a DWORD pseudo random number.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK RDMDW

(*Group:Default*)


VAR_INPUT
	LAST :	DWORD;
END_VAR


VAR_OUTPUT
	RDMDW :	DWORD;
END_VAR


VAR
	RX :	REAL;
	M :	REAL;
	rdm :	rdm;
END_VAR


(*@KEY@: WORKSHEET
NAME: RDMDW
IEC_LANGUAGE: ST
*)
M := INT_TO_REAL(BIT_COUNT(last)); 
rdm(last:=FRACT(M*3.14159265358979323846264338327950288));
RX:=rdm.RDM;
RDMDW := SHL_DWORD(_REAL_TO_DWORD(rx*65535.0),16); 

rdm(last:=FRACT(M*2.71828182845904523536028747135266249));
RX:=rdm.RDM;
RDMDW := RDMDW OR (_REAL_TO_DWORD(rx*65535.0) AND DWORD#16#0000FFFF); 

(* revision history
hm		14. mar 2008		rev 1.0
	original version

hm		18. may. 2008		rev 1.1
	changed constant E to E1

hm		18. oct. 2008		rev 1.2
	using math constants

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
