(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. mar 2009
programmer 	kurt
tested by	hugo

IS_IP4 testet ob ein string eine gültige IPv4 Adresse enthält.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IS_IP4

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	IS_IP4 :	BOOL;
END_VAR


VAR
	COUNT_CHAR :	COUNT_CHAR;
END_VAR


(*@KEY@: WORKSHEET
NAME: IS_IP4
IEC_LANGUAGE: ST
*)
COUNT_CHAR(STR:=str,CHR:=BYTE#46);
IS_IP4 := COUNT_CHAR.COUNT_CHAR = 3;

(* revision history
hm	1. mar. 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	new code

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
