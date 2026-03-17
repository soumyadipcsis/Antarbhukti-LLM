(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: INTERN
*)
(*@KEY@:DESCRIPTION*)
version 1.5	12. nov. 2009
programmer 	hugo
tested by	oscat

this function will retrieve a string from an array of byte starting at position start and stop at position stop.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BUFFER_TO_STRING_NW

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_NW_BUF_LONG;
END_VAR


VAR_INPUT
	SIZE :	UINT;
	START :	UINT;
	STOP :	UINT;
END_VAR


VAR_OUTPUT
	BUFFER_TO_STRING :	oscat_STRING250;
END_VAR


VAR
	sta :	UINT;
	stp :	UINT;
	size2 :	UINT;
	i :	INT;
	BUF_TO_STRING :	BUF_TO_STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: BUFFER_TO_STRING_NW
IEC_LANGUAGE: ST
*)
sta := MIN(START, SIZE - UINT#1);
stp := STOP;
(* check for maximum string_length *)
IF stp - sta + UINT#1 > UINT#250 THEN
	stp := sta + UINT#250 - UINT#1;
END_IF;
stp := MIN(stp, SIZE - UINT#1);
size2 := stp - sta + UINT#1; 
IF size2 > UINT#0 THEN
	FOR i := 0 TO 1 DO
		BUF_TO_STRING.REQ := i > 0;
		BUF_TO_STRING.BUF_FORMAT := TRUE;
		BUF_TO_STRING.BUF_OFFS := UINT_TO_DINT(START);
		BUF_TO_STRING.BUF_CNT := UINT_TO_DINT(size2);
		BUF_TO_STRING.BUFFER := pt;
		BUF_TO_STRING.DST := BUFFER_TO_STRING;
		BUF_TO_STRING();
		pt := BUF_TO_STRING.BUFFER;
		BUFFER_TO_STRING := BUF_TO_STRING.DST;
	END_FOR;
ELSE
	BUFFER_TO_STRING :='';
END_IF;

(* revision History
hm 	5. mar. 2008	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint

hm	13. may. 2008	rev 1.2
	changed type of pointer to array[0..32767]
	changed size of string to STRING_LENGTH

hm	12. jun. 2008	rev 1.3
	check for pointer overrun
	change input start and stop to uint
	added type conversions to avoid warnings under codesys 3.0

hm	23. mar. 2009	rev 1.4
	avoid writing to input stop

hm	12. nov. 2009 rev 1.5
	limit start and stop to size -1

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
