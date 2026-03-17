(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	18. mar. 2011
programmer 	hugo
tested by	tobias

returns the mid value of 3 real inputs.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MID3:REAL

(*Group:Default*)


VAR_INPUT
	IN1 :	REAL;
	IN2 :	REAL;
	IN3 :	REAL;
END_VAR


VAR
	_IN1 :	REAL;
	_IN2 :	REAL;
	_IN3 :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MID3
IEC_LANGUAGE: ST
*)
_IN1 := IN1; (* VAR_INPUT auf Variablen umkopieren , da diese schreibgeschützt sind *)
_IN2 := IN2;
_IN3 := IN3;

IF _IN1 > _IN2 THEN MID3 := _IN1; _IN1 := _IN2; _IN2 := MID3; END_IF;
IF _IN2 > _IN3 THEN _IN2 := _IN3; END_IF;
MID3 := SEL(_IN1 > _IN2, _IN2, _IN1);

(*
hm	1.1.2007	rev 1.1
	rewrote the function for better performance

hm	18. mar. 2011	rev 1.2
	improve performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
