(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.0	30. oct. 2008
programmer 	hugo
tested by	oscat

MATRIX_CODE scans the input of a key_pad (MATRIX) for a sequence of characters.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PIN_CODE

(*Group:Default*)


VAR_INPUT
	CB :	BYTE;
	E :	BOOL;
	PIN :	oscat_STRING8;
END_VAR


VAR_OUTPUT
	TP :	BOOL;
END_VAR


VAR
	POS :	INT := 1;
END_VAR


(*@KEY@: WORKSHEET
NAME: PIN_CODE
IEC_LANGUAGE: ST
*)
tp := FALSE;
IF e THEN

	IF CB = INT_TO_BYTE(GET_CHAR(PIN,POS)) THEN
		pos := pos + 1;
		IF pos > LEN(PIN) THEN
			(* proper code is detected *)
			TP := TRUE;
			pos := 1;
		END_IF;
	ELSE
		pos := 1;
	END_IF;
END_IF;


(* revision history
hm	30. oct. 2008	rev 1.0		
	original version 


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
