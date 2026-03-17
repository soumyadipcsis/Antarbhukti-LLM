(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	hugo
tested by	tobias

this function checks two inputs x and y if they are identical with the first N digits
example : cmp(3.141516,3.141517,6 is true.

(*@KEY@:END_DESCRIPTION*)
FUNCTION CMP:BOOL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	Y :	REAL;
	N :	INT;
END_VAR


VAR
	tmp :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CMP
IEC_LANGUAGE: ST
*)
tmp := ABS(x);
IF tmp > 0.0 THEN
	tmp := EXP10(INT_TO_REAL(FLOOR(LOG(tmp))-N+1));
ELSE
	tmp := EXP10(tmp);
END_IF;
CMP := ABS(X - Y) < tmp;


(* revision history
hm	12. mar. 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	added type conversion for compatibility reasons
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION
