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

this function converts a 32 Bit Real to a dword in a bitwise manner.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REAL_TO_DW

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


VAR_OUTPUT
	REAL_TO_DW :	DWORD;
END_VAR


VAR
	REAL_TO_BUF :	REAL_TO_BUF;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: REAL_TO_DW
IEC_LANGUAGE: ST
*)
(* REAL_TO_BUF muss mit positiver Flanke gstartet werden darum wird dieser *)
(* einmal mit REQ=0 und dann mit REQ=1 aufgerufen                          *)
(* somit kann in jeden zyklus kopiert werden                               *)

FOR I := 0 TO 1 DO
  REAL_TO_BUF.REQ        := I > 0;
  REAL_TO_BUF.BUF_FORMAT := FALSE;
  REAL_TO_BUF.BUF_OFFS   := DINT#0;
  REAL_TO_BUF.BUF_CNT    := DINT#4;
  REAL_TO_BUF.SRC        := X;
  REAL_TO_BUF.BUFFER     := REAL_TO_DW;
  REAL_TO_BUF();
  X          := REAL_TO_BUF.SRC;
  REAL_TO_DW := REAL_TO_BUF.BUFFER;
END_FOR;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
