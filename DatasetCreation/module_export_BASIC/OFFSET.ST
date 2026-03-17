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
all selected offsets are added at the same time.
with the input D a default value instead of the input X can be used.
(*@KEY@:END_DESCRIPTION*)
FUNCTION OFFSET:REAL

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
NAME: OFFSET
IEC_LANGUAGE: ST
*)
IF D THEN Offset := default; ELSE Offset := X; END_IF;
IF O1 THEN Offset := Offset + offset_1; END_IF;
IF O2 THEN Offset := Offset + offset_2; END_IF;
IF O3 THEN Offset := Offset + offset_3; END_IF;
IF O4 THEN Offset := Offset + offset_4; END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
