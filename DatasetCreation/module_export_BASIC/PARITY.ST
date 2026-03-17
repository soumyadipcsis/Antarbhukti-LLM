(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GATE_LOGIC
*)
(*@KEY@:DESCRIPTION*)
version 1.3	18 feb 2008
programmer 	hugo
tested BY	hans

this function calculates the even parity of an input Dword
the output will be true if the amount of high bits are an odd number.
(*@KEY@:END_DESCRIPTION*)
FUNCTION PARITY:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
END_VAR


VAR
	in2 :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: PARITY
IEC_LANGUAGE: ST
*)
in2:=in;
WHILE in2 > DWORD#0 DO
	parity := parity XOR BIT_OF_DWORD(in2,0) XOR BIT_OF_DWORD(in2,1) XOR BIT_OF_DWORD(in2,2) XOR BIT_OF_DWORD(in2,3);
	in2 := SHR(in2,4);
END_WHILE;

(* code before rev 1.2
WHILE in > 0 DO
	IF in.0 THEN cnt := cnt +1; END_IF;
	in := SHR(in,1);
END_WHILE;
IF (cnt MOD 2) = 1 THEN parity := TRUE; ELSE parity := FALSE; END_IF;
*)

(* revision history

rev 1.0 hm 1 sep 2006
	original version

rev 1.1 hm 10.9.2007
	changed algorithm to improve performance

rev 1.2	hm	8 dec 2007
	changed algorithm to improve performance

rev 1.3	hm	18 feb 2008
	changed algorithm to improve performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
