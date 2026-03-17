(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.0	16 jan 2008
programmer 	hugo
tested BY	tobias

Count_R is a byte counter with independen up and dn inputs. the counter counts from 0 to mx and continues at 0 after is has reached mx
a step input sets the counters stepping width.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK COUNT_BR

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	IN :	BYTE;
	UP :	BOOL;
	DN :	BOOL;
	STEP :	BYTE := BYTE#1;
	MX :	BYTE := BYTE#255;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	CNT :	BYTE;
END_VAR


VAR
	last_up :	BOOL;
	last_dn :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: COUNT_BR
IEC_LANGUAGE: ST
*)
IF rst THEN
	cnt := BYTE#0;
ELSIF set THEN
	cnt := INT_TO_BYTE(LIMIT(0,_BYTE_TO_INT(in),_BYTE_TO_INT(mx)));
ELSIF up AND NOT last_up THEN
	cnt := INT_TO_BYTE(inc(_BYTE_TO_INT(cnt),_BYTE_TO_INT(step),_BYTE_TO_INT(mx)));
ELSIF dn AND NOT last_dn THEN
	cnt := INT_TO_BYTE(inc(_BYTE_TO_INT(cnt),_BYTE_TO_INT(step) * -1,_BYTE_TO_INT(mx)));
END_IF;
last_up := up;
last_dn := dn;

(* revision history
hm	16. jan 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
