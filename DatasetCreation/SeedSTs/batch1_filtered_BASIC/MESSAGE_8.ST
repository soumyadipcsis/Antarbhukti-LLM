(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. mar. 2008
programmer 	hugo
tested by	tobias

this function generates one out of 4 messages specified by S1 .. S8.
the selected message will be presented at the output M.
In1 has higher priority then In2 which has higher priority then IN3 and in8 has the lowest priority.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MESSAGE_8

(*Group:Default*)


VAR_INPUT
	IN1 :	BOOL;
	IN2 :	BOOL;
	IN3 :	BOOL;
	IN4 :	BOOL;
	IN5 :	BOOL;
	IN6 :	BOOL;
	IN7 :	BOOL;
	IN8 :	BOOL;
	S1 :	STRING;
	S2 :	STRING;
	S3 :	STRING;
	S4 :	STRING;
	S5 :	STRING;
	S6 :	STRING;
	S7 :	STRING;
	S8 :	STRING;
END_VAR


VAR_OUTPUT
	M :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: MESSAGE_8
IEC_LANGUAGE: ST
*)
(* check if an alarm is present if yes set the output M otherwise clear M *)
IF in1 THEN
	M := S1;
ELSIF in2 THEN
	M := S2;
ELSIF in3 THEN
	M := S3;
ELSIF in4 THEN
	M := S4;
ELSIF in5 THEN
	M := S5;
ELSIF in6 THEN
	M := S6;
ELSIF in7 THEN
	M := S7;
ELSIF in8 THEN
	M := S8;
ELSE
	M := '';
END_IF;

(* revision history
hm	26.12.2007		rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
