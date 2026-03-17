(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0	12 jan 2007
programmer 	oscat
tested by	tobias

The Function offset adds offsets to an analog signal depending on digital inputs.
one offset can be added at the same time, if more then one input is true, the one with the highest number (o1 .. o4) will be used.
The input D will select a default value instead of X for input.
(*@KEY@:END_DESCRIPTION*)
FUNCTION OFFSET2:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	O1 :	BOOL;
	O2 :	BOOL;
	O3 :	BOOL;
	O4 :	BOOL;
	D :	BOOL;
	OFFSET_1 :	REAL;
	OFFSET_2 :	REAL;
	OFFSET_3 :	REAL;
	OFFSET_4 :	REAL;
	DEFAULT :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: OFFSET2
IEC_LANGUAGE: ST
*)
IF D THEN Offset2 := default; ELSE Offset2 := X; END_IF;
IF O4 THEN Offset2 := Offset2 + offset_4;
ELSIF O3 THEN Offset2 := Offset2 + offset_3;
ELSIF O2 THEN Offset2 := Offset2 + offset_2;
ELSIF O1 THEN Offset2 := Offset2 + offset_1;
END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
