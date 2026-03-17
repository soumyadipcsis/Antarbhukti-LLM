(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LIST_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 2.0	21. mar. 2011
programmer 	hugo
tested by	oscat

LIST_CLEAN bereinigt eine liste von leeren Elementen.
die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LIST_CLEAN

(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
END_VAR


VAR_IN_OUT
	LIST :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	LIST_CLEAN :	BOOL;
END_VAR


VAR
	BUF_TO_STRING :	BUF_TO_STRING;
	pt :	oscat_bya_LIST_CLEAN;
	read :	INT;
	write :	INT := 1;
	last :	BYTE;
	c :	BYTE;
	cnt :	INT;
	z :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LIST_CLEAN
IEC_LANGUAGE: ST
*)
last := BYTE#0;
cnt := LEN(LIST);
write := 0;
FOR read := 1 TO cnt DO
	c := INT_TO_BYTE(GET_CHAR(LIST,read));
	IF c <> SEP OR last <> SEP THEN
		write := write + 1;
		pt[write] := c;
	END_IF;
	last := c;
END_FOR;
IF last = SEP THEN write := write - 1; END_IF;

FOR z := 0 TO 1 DO
  BUF_TO_STRING.REQ        := z > 0;
  BUF_TO_STRING.BUF_FORMAT := TRUE;
  BUF_TO_STRING.BUF_OFFS   := DINT#0;
  BUF_TO_STRING.BUF_CNT    := INT_TO_DINT(write);
  BUF_TO_STRING.BUFFER     := pt;
  BUF_TO_STRING.DST        := LIST;
  BUF_TO_STRING();
  pt := BUF_TO_STRING.BUFFER;
  LIST := BUF_TO_STRING.DST;
END_FOR;

LIST_CLEAN := TRUE; (* return TRUE *)

(* revision histroy
hm	28. jun. 2008	rev 1.0
	original release

hm	19. jan. 2011	rev 1.1
	changed string(255) to string(LIST_LENGTH)

hm	21. mar. 2011	rev 2.0
	all elements start with SEP

*)	

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
