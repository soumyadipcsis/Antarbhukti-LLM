(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_PULSE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.2	30. oct. 2008
programmer 	hugo
tested by	oscat

Transparent Latch with asynchronous reset
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LTCH

(*Group:Default*)


VAR_INPUT
	D :	BOOL;
	L :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: LTCH
IEC_LANGUAGE: ST
*)
(* as long as L is true, the latch is transparent and and change of D is transferred to Q *)
(* of course only when there is no asynchronous reset *)
IF rst THEN				(* if asynchronous reset then Q=0 *)
	Q := FALSE;
ELSIF L THEN			(* latch is transparent *)
	Q := D;
END_IF;


(* revision history
hm	4. aug 2006		rev 1.0
	original version

hm	27. dec 2007	rev 1.1
	changed code for better performance

hm	30. oct. 2008	rev 1.2
	deleted unnecessary init with 0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
