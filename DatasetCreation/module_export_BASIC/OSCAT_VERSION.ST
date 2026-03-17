(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16 dec 2007
programmer 	hugo
tested by	tobias

oscat_version returns the version number in dword format
132 is library version 1.32
if IN = true, the release date will be returned
(*@KEY@:END_DESCRIPTION*)
FUNCTION OSCAT_VERSION:DWORD

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: OSCAT_VERSION
IEC_LANGUAGE: ST
*)
IF in THEN
	Oscat_version := UDINT_TO_DWORD(set_Date(2012,01,02));
ELSE
	Oscat_version := DWORD#333;
END_IF;

(* revision history
hm	6. oct 2006	rev 1.0
	original version

hm	16. dec 2007	rev 1.1
	added possibility to return date and version depending on IN.

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
