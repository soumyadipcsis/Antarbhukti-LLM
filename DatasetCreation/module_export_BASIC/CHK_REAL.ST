(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.0	20. jan. 2011
programmer 	hugo
tested by	tobias

this function checks a floating point variable of type real (IEEE754-32Bits) for NAN and infinity
RETURN values: #0 = normal value, #20 = +infinity, #40 = -infinty, #80 = NAN

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CHK_REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
END_VAR


VAR_OUTPUT
	CHK_REAL :	BYTE;
END_VAR


VAR
	tmp :	DWORD;
	REAL_TO_DW :	REAL_TO_DW;
END_VAR


(*@KEY@: WORKSHEET
NAME: CHK_REAL
IEC_LANGUAGE: ST
*)
REAL_TO_DW(X:=X); (* move real to dword, real_to_dword does not work becasze it treats dword as a number on many systems *)
tmp := ROL(REAL_TO_DW.REAL_TO_DW,1);(* rotate left foir easy checking, sign will be at lease significant digit *)
IF tmp < DWORD#16#FF000000 THEN
	CHK_REAL := BYTE#16#00;	(* normalized and denormalized numbers *)
ELSIF tmp = DWORD#16#FF000000 THEN
	CHK_REAL := BYTE#16#20;	(* X is +infinity see IEEE754 *)
ELSIF tmp = DWORD#16#FF000001 THEN
	CHK_REAL := BYTE#16#40;	(* X is -infinity see IEEE754 *)
ELSE
	CHK_REAL := BYTE#16#80;	(* X is NAN see IEEE754 *)
END_IF;

(* revision history
hm	 20. jan. 2011	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
