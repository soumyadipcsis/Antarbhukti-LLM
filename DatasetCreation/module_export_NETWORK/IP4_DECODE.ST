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

IP4_DECODE testet ob ein string eine gültige IPv4 Adresse enthält und gibt die 4 Bytes der IP Adresse als DWORD zurück.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IP4_DECODE

(*Group:Default*)


VAR_INPUT
	STR :	oscat_STRING80;
END_VAR


VAR_OUTPUT
	IP4_DECODE :	DWORD;
END_VAR


VAR
	pos :	INT;
	IS_NUM :	IS_NUM;
END_VAR


(*@KEY@: WORKSHEET
NAME: IP4_DECODE
IEC_LANGUAGE: ST
*)
IP4_DECODE := DWORD#0;
pos := FIND(str, '.');
WHILE pos > 0 DO
	IP4_DECODE := SHL(IP4_DECODE,8);
	IF POS > 1 AND POS <= 4 THEN
		IS_NUM(STR:=LEFT(str,pos - 1));
		IF IS_NUM.IS_NUM THEN
			IP4_DECODE := IP4_DECODE OR STRING_TO_DWORD(IS_NUM.STR);
		END_IF;
	END_IF;
	str := DELETE(str, pos, 1);
	pos := FIND(str, '.');
END_WHILE;

IP4_DECODE := SHL(IP4_DECODE,8);
IS_NUM(STR:=str);
IF IS_NUM.IS_NUM THEN
  IP4_DECODE := IP4_DECODE OR STRING_TO_DWORD(str);
END_IF;

(* revision history
hm		29. feb 2008	rev 1.0
	original version

hm	10. mar. 2009	rev 1.1
	new algorythm
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
