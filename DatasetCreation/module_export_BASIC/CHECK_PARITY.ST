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
tested by	tobias

this function checks for an even partity for a dword and partity bit.
(*@KEY@:END_DESCRIPTION*)
FUNCTION CHECK_PARITY:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	P :	BOOL;
END_VAR


VAR
	in2 :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: CHECK_PARITY
IEC_LANGUAGE: ST
*)
in2:=in;
check_parity := NOT p;
WHILE in2 > DWORD#0 DO
	check_parity := check_parity XOR BIT_OF_DWORD(in2,0) XOR BIT_OF_DWORD(in2,1) XOR BIT_OF_DWORD(in2,2) XOR BIT_OF_DWORD(in2,3);
	in2 := SHR(in2,4);
END_WHILE;

(* code before rev 1.2
WHILE in > 0 DO
	IF in.0 THEN cnt := cnt + 1; END_IF;
	in := SHR(in,1);
END_WHILE;
check_parity := even(cnt) XOR P;
*)


(* revision history

rev 1.0 HM  1.oct.2006

rev 1.1 hm	10.sep.2007
	changed algorithm to improove performance

rev 1.2	hm	8 dec 2007
	changed algorithm to improove performance

rev 1.3 hm	18. feb 2008
	changed algorithm to improove performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
