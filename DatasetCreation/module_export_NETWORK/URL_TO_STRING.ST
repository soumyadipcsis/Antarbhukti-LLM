(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.1	10. may. 2010
programmer 	hugo
tested by	oscat

URL_TO_STRING generates a string from URL information suppied in IN..
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK URL_TO_STRING

(*Group:Default*)


VAR_INPUT
	IN :	oscat_url;
END_VAR


VAR_OUTPUT
	URL_TO_STRING :	oscat_STRING250;
END_VAR


(*@KEY@: WORKSHEET
NAME: URL_TO_STRING
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

(* attach protocol *)
IF NE_STRING(IN.PROTOCOL,'') THEN URL_TO_STRING := CONCAT(IN.PROTOCOL,'://'); END_IF;

(* attach user and password *)
IF NE_STRING(IN.USER,'') THEN
	URL_TO_STRING := CONCAT(URL_TO_STRING, IN.USER);
	IF NE_STRING(IN.PASSWORD,'') THEN
		URL_TO_STRING := CONCAT(URL_TO_STRING, ':');
		URL_TO_STRING := CONCAT(URL_TO_STRING, IN.PASSWORD);
	END_IF;
	URL_TO_STRING := CONCAT(URL_TO_STRING, '@');
END_IF;

(* attach domain *)
URL_TO_STRING := CONCAT(URL_TO_STRING, IN.DOMAIN);

(* attach Port *)
IF IN.PORT > WORD#0 THEN
	URL_TO_STRING := CONCAT(URL_TO_STRING, ':');
	URL_TO_STRING := CONCAT(URL_TO_STRING, WORD_TO_STRING(IN.PORT,'%u'));
END_IF;

(* attach path *)
URL_TO_STRING := CONCAT(URL_TO_STRING, IN.PATH);

(* attach query *)
IF NE_STRING(IN.QUERY,'') THEN
	URL_TO_STRING := CONCAT(URL_TO_STRING, '?');
	URL_TO_STRING := CONCAT(URL_TO_STRING, IN.QUERY);
END_IF;

(* attach anchor *)
IF NE_STRING(IN.ANCHOR,'') THEN
	URL_TO_STRING := CONCAT(URL_TO_STRING, '#');
	URL_TO_STRING := CONCAT(URL_TO_STRING, IN.ANCHOR);
END_IF;

(* revision history
hm	18. apr 2008	rev 1.0
	original version

ks	10. mai. 2008	rev 1.1
	stringlength 250
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
