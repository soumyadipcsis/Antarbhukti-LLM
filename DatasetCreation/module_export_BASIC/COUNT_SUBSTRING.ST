(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	20. jan. 2011
programmed	kurt
tested by	tobias

count_substring returns the number of occurences of a substring in a string


(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK COUNT_SUBSTRING

(*Group:Default*)


VAR_INPUT
	SEARCH :	STRING;
	STR :	STRING;
END_VAR


VAR_OUTPUT
	COUNT_SUBSTRING :	INT;
END_VAR


VAR
	pos :	INT;
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: COUNT_SUBSTRING
IEC_LANGUAGE: ST
*)
COUNT_SUBSTRING := 0;
size := LEN(SEARCH);
REPEAT
   pos := FIND(STR,SEARCH);
   IF pos > 0 THEN
      STR := REPLACE(STR, '', size,pos);
      COUNT_SUBSTRING := COUNT_SUBSTRING + 1;
   END_IF;
UNTIL pos = 0
END_REPEAT;

(* revision history
ks	20. jan. 2011	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
