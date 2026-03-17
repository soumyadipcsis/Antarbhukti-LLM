(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.0	4. mar 2008
programmer 	hugo
tested by	oscat

IP4_CHECK testet ob eine Network IP und Local_IP im selben Subnet sind.
(*@KEY@:END_DESCRIPTION*)
FUNCTION IP4_CHECK:BOOL

(*Group:Default*)


VAR_INPUT
	NIP :	DWORD;
	LIP :	DWORD;
	SM :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: IP4_CHECK
IEC_LANGUAGE: ST
*)
IP4_CHECK := (NIP AND sm) = (LIP AND SM);

(* revision history
hm		4. mar 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
