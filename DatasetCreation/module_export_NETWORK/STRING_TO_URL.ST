(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. dec. 2010
programmer 	hugo
tested by	oscat

URL splits a unifrom resource locator in its conponents.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK STRING_TO_URL

(*Group:Default*)


VAR_INPUT
	STR :	oscat_STRING250;
	DEFAULT_PROTOCOL :	oscat_STRING20 := 'http';
	DEFAULT_PATH :	oscat_STRING80 := '/';
END_VAR


VAR_OUTPUT
	STRING_TO_URL :	oscat_url;
END_VAR


VAR
	pos :	INT;
	pos2 :	INT;
	temp :	STRING;
	x :	oscat_STRING250;
END_VAR


(*@KEY@: WORKSHEET
NAME: STRING_TO_URL
IEC_LANGUAGE: ST
*)
(*

http://hans:geheim@www.example.org:80/demo/example.cgi?land=de&stadt=aa#abschnitt1
|      |    |      |               | |                 |                |
|      |    |      Host            | Pfad              Query            Anker
|      |    Passwort               Port
|      Benutzer
Protokoll

*)

(* check if string is empty and return empty url *)
IF EQ_STRING(STR,'') THEN
	RETURN;
END_IF;

(* extract the protocol *)
(* first we check if the optional protocol is specified ending with a :// *)
pos := FIND(STR, '://');
IF pos > 0 THEN
	(* store protocol and restore the rest of url in temp *)
	STRING_TO_URL.PROTOCOL := LEFT(STR, pos - 1);
	x := RIGHT(STR, LEN(STR) - pos - 2);
ELSE
	x := STR;
	STRING_TO_URL.PROTOCOL := DEFAULT_PROTOCOL;
END_IF;

(* extract user and password if present ending with a @ *)
pos := FIND(x, '@');
IF pos > 0 THEN
	(* extract user *)
	pos2 := FIND(x,':')+1;
	IF pos2 > 1 AND pos2 <= pos THEN
		STRING_TO_URL.USER := LEFT(x,pos2 - 2);
		STRING_TO_URL.PASSWORD := MID(x, pos - pos2, pos2);
	ELSE
		STRING_TO_URL.USER := LEFT(x, pos - 2);
		STRING_TO_URL.PASSWORD := '';
	END_IF;
	x := RIGHT(x, LEN(x) - pos);
ELSE
	STRING_TO_URL.USER := '';
	STRING_TO_URL.PASSWORD := '';
END_IF;

(* extract anchor *)
pos := FIND(x, '#');
IF pos > 0 THEN
	STRING_TO_URL.ANCHOR := RIGHT(x, LEN(x) - pos);
	x := LEFT(x, pos - 1);
ELSE
	STRING_TO_URL.ANCHOR := '';
END_IF;

(* extract query  *)
pos := FIND(x, '?');
IF pos > 0 THEN
	STRING_TO_URL.QUERY := RIGHT(x, LEN(x) - pos);
	x := LEFT(x, pos - 1);
ELSE
	STRING_TO_URL.QUERY := '';
END_IF;

(* extract path  *)
pos := FIND(x, '/');
IF pos > 0 THEN
	STRING_TO_URL.PATH := RIGHT(x, LEN(x) - pos + 1);
	x := LEFT(x, pos - 1);
ELSE
	STRING_TO_URL.PATH := DEFAULT_PATH;
END_IF;

(* extract port and leave domain *)
pos := FIND(x, ':');
IF pos > 0 THEN
    temp := RIGHT(x, LEN(x) - pos);
	STRING_TO_URL.PORT := STRING_TO_WORD(temp);
	STRING_TO_URL.DOMAIN := LEFT(x, pos - 1);
ELSE
	STRING_TO_URL.PORT := WORD#0;
	STRING_TO_URL.DOMAIN := x;
END_IF;

(* revision history
hm		18. apr 2008	rev 1.0
	original version

ks		20. dec. 2010	rev 1.1
	stringlength 250 , var x

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
