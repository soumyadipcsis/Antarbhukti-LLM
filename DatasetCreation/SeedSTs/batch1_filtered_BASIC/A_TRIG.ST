(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	23. oct. 2008
programmer 	hugo
tested by	oscat

this block is similar to the IEC Standard R_trig and F_trig but it monitors a REAL for change.
if the valiue on IN changes more then D from the last value it will generate trigger and display the difference in output D.
the trigger will only be active for one cycle.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK A_TRIG

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	RES :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	D :	REAL;
END_VAR


VAR
	last_in :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: A_TRIG
IEC_LANGUAGE: ST
*)
D := IN - LAST_IN;
IF ABS(D) >= res THEN
	Q := TRUE;
	last_in := IN;
ELSE
	Q := FALSE;
END_IF;


(* revision history

hm 	16. jul. 2008	rev 1.0
	original version released

hm	23. oct. 2008	rev 1.1
	code optimization
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
