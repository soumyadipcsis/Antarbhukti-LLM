(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.2	10. mar. 2009
programmer 	hugo
tested by	oscat

FILTER_WAV is a moving average filter with programmable length N for DWORD Data.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILTER_WAV

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	W :	oscat_arr_0_15;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Y :	REAL;
END_VAR


VAR
	init :	BOOL;
	buffer :	oscat_arr_0_15;
	i :	INT;
	n :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILTER_WAV
IEC_LANGUAGE: ST
*)
(* startup initialisation *)
IF NOT init OR rst THEN
	init := TRUE;
	FOR i := 0 TO 15 DO
		buffer[i] := X;
	END_FOR;
	i := 15;
	Y := X;
ELSE
	i := INC1(i, 16);
	buffer[i] := X;
END_IF;

(* calculate the weighted average *)
Y := 0.0;
FOR n := 0 TO 15 DO
	Y := buffer[i] * W[n] + Y;
	i := DEC1(i, 16);
END_FOR;


(*
hm 	14. oct. 2008	rev 1.0
	original version

hm	27. oct. 2008	rev 1.1
	changed _DEC and _INC to DEC1 and INC1

hm	10. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
