(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.COMPLEX
*)
(*@KEY@:DESCRIPTION*)
version 1.0	21 feb 2008
programmer 	hugo
tested by	oscat

this function calculates the complex power function x to the power of y
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CPOW

(*Group:Default*)


VAR_INPUT
	X :	oscat_complex;
	Y :	oscat_complex;
END_VAR


VAR_OUTPUT
	CPOW :	oscat_complex;
END_VAR


VAR
	CLOG :	CLOG;
	CEXP :	CEXP;
	CMUL :	CMUL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CPOW
IEC_LANGUAGE: ST
*)
CLOG(X:=X);
CMUL(X:=Y,Y:=CLOG.CLOG);
CEXP(X:=CMUL.CMUL);
CPOW := CEXP.CEXP;

(* revision history
hm	21. feb 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
