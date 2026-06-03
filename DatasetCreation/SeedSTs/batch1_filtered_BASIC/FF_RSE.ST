(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.0	16. jul. 2008
programmer 	hugo
tested by	oscat

this is a rising edge triggered rs flip flop
a rising edge on CS sets Q = TRUE and a rising edge on CR sets Q = FALSE.
CR has priority over CS.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FF_RSE

(*Group:Default*)


VAR_INPUT
	CS :	BOOL;
	CR :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	es :	BOOL;
	er :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FF_RSE
IEC_LANGUAGE: ST
*)
IF rst THEN
	(* asynchronous reset *)
	Q := FALSE;
ELSIF CR AND NOT er THEN
	(* rising edge on CR *)
	Q := FALSE;
ELSIF CS AND NOT es THEN
	(* rising edge on CS *)
	Q := TRUE;
END_IF;

es := CS;
er := CR;

(* revision history

hm	16. jul. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
