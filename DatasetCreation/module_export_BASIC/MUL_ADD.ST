(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11 nov 2007
programmer 	hugo
tested by	tobias

this function multiplies an input X with K and adds Offset O to the result.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MUL_ADD:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	K :	REAL;
	O :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MUL_ADD
IEC_LANGUAGE: ST
*)
MUL_ADD := X * K + O;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
