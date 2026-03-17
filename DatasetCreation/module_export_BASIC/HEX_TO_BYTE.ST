(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. sep. 2008
programmer 	hugo
tested by		oscat

HEX_TO_BYTE converts a Hexadecimal string into a byte.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HEX_TO_BYTE

(*Group:Default*)


VAR_INPUT
	HEX :	oscat_STRING5;
END_VAR


VAR_OUTPUT
	HEX_TO_BYTE :	BYTE;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	X :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: HEX_TO_BYTE
IEC_LANGUAGE: ST
*)
HEX_TO_BYTE := BYTE#0;
stop := LEN(HEX);
FOR I := 1 TO stop DO
	(* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := GET_CHAR(Hex,I);
	(* calculate the value of the digit *)
	IF X > 47 AND x < 58 THEN
	    HEX_TO_BYTE := SHL_BYTE(HEX_TO_BYTE,4) OR INT_TO_BYTE (X - 48);
	ELSIF X > 64 AND X < 71 THEN
	    HEX_TO_BYTE := SHL_BYTE(HEX_TO_BYTE,4) OR INT_TO_BYTE (X - 55);
	ELSIF X > 96 AND X < 103 THEN
	    HEX_TO_BYTE := SHL_BYTE(HEX_TO_BYTE,4) OR INT_TO_BYTE (X - 87);
	END_IF;
END_FOR;

(* revision histroy
hm	18. jun. 2008	rev 1.0
	original release

hm	20. sep.2008	rev 1.1
	changed length of input string from 20 to 5

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
