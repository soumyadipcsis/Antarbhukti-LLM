(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar. 2009
programmer 	kurt
tested by	hugo

IP4_TO_STRING erzeugt eine IP Adresse als String aus einem DWORD..
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IP4_TO_STRING

(*Group:Default*)


VAR_INPUT
	IP4 :	DWORD;
END_VAR


VAR_OUTPUT
	IP4_TO_STRING :	STRING;
END_VAR


VAR
	s1 :	oscat_string10;
	s2 :	oscat_string10;
END_VAR


(*@KEY@: WORKSHEET
NAME: IP4_TO_STRING
IEC_LANGUAGE: ST
*)

s1 := CONCAT(BYTE_TO_STRING(BYTE_OF_DWORD(IP4,BYTE#1),'.%0u'),BYTE_TO_STRING(BYTE_OF_DWORD(IP4,BYTE#0),'.%0u'));
s2 := CONCAT(BYTE_TO_STRING(BYTE_OF_DWORD(IP4,BYTE#3),'%0u'),BYTE_TO_STRING(BYTE_OF_DWORD(IP4,BYTE#2),'.%0u'));
IP4_TO_STRING := CONCAT(s2,s1);

(* revision history
hm	22. apr 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	improved code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
