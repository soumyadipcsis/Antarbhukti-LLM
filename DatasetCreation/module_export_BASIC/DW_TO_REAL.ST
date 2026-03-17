(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0	18. apr. 2008
programmer 	hugo
tested by	tobias

this function converts a DWORD to REAL in a bitwise manner.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DW_TO_REAL

(*Group:Default*)


VAR_INPUT
	X :	DWORD;
END_VAR


VAR_OUTPUT
	DW_TO_REAL :	REAL;
END_VAR


VAR
	BUF_TO_REAL :	BUF_TO_REAL;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DW_TO_REAL
IEC_LANGUAGE: ST
*)
(* BUF_TO_REAL muss mit positiver Flanke gstartet werden darum wird dieser *)
(* einmal mit REQ=0 und dann mit REQ=1 aufgerufen                          *)
(* somit kann in jeden zyklus kopiert werden                               *)

FOR I := 0 TO 1 DO
  BUF_TO_REAL.REQ        := I > 0;
  BUF_TO_REAL.BUF_FORMAT := FALSE;
  BUF_TO_REAL.BUF_OFFS   := DINT#0;
  BUF_TO_REAL.BUF_CNT    := DINT#4;
  BUF_TO_REAL.BUFFER     := X;
  BUF_TO_REAL.DST        := DW_TO_REAL;
  BUF_TO_REAL();
  X           := BUF_TO_REAL.BUFFER;
  DW_TO_REAL  := BUF_TO_REAL.DST;
END_FOR;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
