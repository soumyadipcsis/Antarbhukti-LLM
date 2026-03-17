(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: FILE
*)
(*@KEY@:DESCRIPTION*)
version 1.0		01. jan. 2011
programmer		ks
tested by		ks

FILE_PATH_SPLIT zerlegt einen Dateipfad in einzelne Elemente und legt diese in einer Datenstruktur ab.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILE_PATH_SPLIT

(*Group:Default*)


VAR_INPUT
	FILENAME :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	FILE_PATH_SPLIT :	BOOL;
END_VAR


VAR_IN_OUT
	X :	oscat_FILE_PATH_DATA;
END_VAR


VAR
	b :	INT;
	c :	INT;
	d :	oscat_STRING1;
	p1 :	INT;
	p2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILE_PATH_SPLIT
IEC_LANGUAGE: ST
*)
X.DRIVE := '';
X.DIRECTORY := '';
X.FILENAME := '';
p1 := 0;
p2 := 0;
c := LEN(FILENAME);
IF c = 0 THEN
	FILE_PATH_SPLIT := FALSE;
	RETURN;
END_IF;

FOR b := 1 TO c DO
	d := MID(FILENAME, 1, b);
	IF EQ_STRING(d,':') THEN
		p1 := b;
	ELSIF EQ_STRING(d,'/') OR EQ_STRING(d,'\') THEN
		p2 := b;
	END_IF;
END_FOR;

IF p1 = 2 THEN
	X.DRIVE := LEFT(FILENAME,p1);
END_IF;

IF p2 > 0 AND p2 > p1 THEN
	X.DIRECTORY := MID(FILENAME,p2-p1,p1+1); (* len , pos *)
END_IF;

X.FILENAME := RIGHT(FILENAME,c - MAX (p1,p2));
FILE_PATH_SPLIT := TRUE;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
