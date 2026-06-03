(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.0		17. feb. 2011
programmer 	    hugo
tested by		oscat

this function calculates a ramp and limits the output to 0 .. 255 without overflow problems

(*@KEY@:END_DESCRIPTION*)
FUNCTION FRMP_B:BYTE

(*Group:Default*)


VAR_INPUT
	START :	BYTE;
	DIR :	BOOL;
	TD :	TIME;
	TR :	TIME;
END_VAR


(*@KEY@: WORKSHEET
NAME: FRMP_B
IEC_LANGUAGE: ST
*)
IF TD < TR THEN
	FRMP_B := MIN(UDINT_TO_BYTE(DWORD_TO_UDINT(SHL(TIME_TO_DWORD(TD), 8)) / TIME_TO_UDINT(TR)), SEL(DIR, START, USINT_TO_BYTE(USINT#255 - BYTE_TO_USINT(START))));
	IF DIR THEN
		FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) + BYTE_TO_USINT(FRMP_B));
	ELSE
		FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) - BYTE_TO_USINT(FRMP_B));
	END_IF;
ELSE
	FRMP_B := SEL(DIR, BYTE#0, BYTE#255);
END_IF;

(* revision history

17. feb. 2011	rev 1.0
	new module

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
