(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	27. oct. 2008
programmer 	hugo
tested by	oscat

This is a decrement function which decrements the variable X by 1 and if 0 is reached, it begins with M again.
_dec1(3,X) will generate 3,2,1,0,3,2,...
(*@KEY@:END_DESCRIPTION*)
FUNCTION DEC1:INT

(*Group:Default*)


VAR_INPUT
	X :	INT;
	N :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEC1
IEC_LANGUAGE: ST
*)
IF X = 0 THEN
	DEC1 := N - 1;
ELSE
	DEC1 := X - 1;
END_IF;


(* this is a very elegant version but 50% slower
X := (X - 1 + N) MOD N;
*)


(* revision history
hm	13. oct. 2008	rev 1.0
	original version

hm	27. oct. 2008	rev 1.1
	added statement to return value for compatibility reasons
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
