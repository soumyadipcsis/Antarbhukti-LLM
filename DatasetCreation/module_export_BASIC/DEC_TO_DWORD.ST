(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	30. sep. 2008
programmer 	hugo
tested by		oscat

DEC_TO_DWORD converts a decimal string into a DWORD.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DEC_TO_DWORD

(*Group:Default*)


VAR_INPUT
	DEC :	oscat_STRING20;
END_VAR


VAR_OUTPUT
	DEC_TO_DWORD :	DWORD;
END_VAR


VAR
	i :	INT;
	X :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DEC_TO_DWORD
IEC_LANGUAGE: ST
*)
DEC_TO_DWORD := DWORD#0;
stop := LEN(DEC);
FOR I := 1 TO stop DO
	(* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    X := GET_CHAR(DEC,I);
	(* calculate the value of the digit *)
	IF X > 47 AND X < 58 THEN
		DEC_TO_DWORD := UDINT_TO_DWORD(DWORD_TO_UDINT(DEC_TO_DWORD) * UDINT#10 + _INT_TO_UDINT(X) - UDINT#48);
	END_IF;
END_FOR;

(*
version 1.1	30. sep. 2008
programmer 	hugo
tested by		oscat

DEC_TO_DWORD converts a decimal string into a DWORD.

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
