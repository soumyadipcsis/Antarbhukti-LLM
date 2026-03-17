(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.0	02. feb 2011
programmer 	kurt
tested by	oscat

network_version returns the version number in dword format
110 is library version 1.10
if IN = true, the release date will be returned
(*@KEY@:END_DESCRIPTION*)
FUNCTION NETWORK_VERSION:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: NETWORK_VERSION
IEC_LANGUAGE: ST
*)
IF in THEN
	NETWORK_VERSION := UDINT_TO_DWORD(set_Date(2011,12,01));
ELSE
	NETWORK_VERSION := DWORD#121;
END_IF;

(* revision history
hm	2. feb 2011	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
