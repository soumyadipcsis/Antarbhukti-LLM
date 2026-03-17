(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	2 jan 2008
programmer 	hugo
tested by	tobias

driver_1 is a multi purpose driver.
a rising edge in in sets the output high if toggle is flase. while toggle is true, a rising edge on in toggles the output Q.
if a timeout is specified the output q will be reset to false automatically after the timeout has elapsed.
a asynchronous reset and set will force the output high or low respectively.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DRIVER_1

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	IN :	BOOL;
	RST :	BOOL;
	TOGGLE_MODE :	BOOL;
	TIMEOUT :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	off :	TON;
	edge :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DRIVER_1
IEC_LANGUAGE: ST
*)
IF off.Q THEN Q := FALSE; END_IF;
IF rst THEN
	Q := FALSE;
ELSIF set THEN
	Q := TRUE;
ELSIF IN AND NOT edge THEN
	IF toggle_mode THEN q := NOT Q; ELSE q := TRUE; END_IF;
END_IF;
edge := in;
IF timeout > t#0s THEN off(in := Q, PT := Timeout); END_IF;


(* revision history
hm	2. jan 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
