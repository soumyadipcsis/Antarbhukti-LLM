(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LIST_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.0		21. mar. 2011
programmer 	    hugo
tested by		oscat

LIST_ADD hängt ein weiteres element ans ende einer liste.
die liste liegt als string von elementen vor die mit den zeichen SEP am anfang makiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_ADD

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
	INS :	oscat_STRING250;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_ADD :	BOOL;
END_VAR


VAR
	CHR_TO_STRING :	CHR_TO_STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_ADD
IEC_LANGUAGE: ST
*)
IF LEN(LIST) + LEN(INS) + 1 <= 250 THEN 
  CHR_TO_STRING(C:=SEP);
  LIST := CONCAT(LIST, CHR_TO_STRING.CHR_TO_STRING);
  LIST := CONCAT(LIST, INS);
  LIST_ADD := TRUE;
ELSE
  LIST_ADD := FALSE;
END_IF;

(* revision histroy

hm	21. mar. 2011	rev 2.0
	original release
*)	

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
