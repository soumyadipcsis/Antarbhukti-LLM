(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	11. mar. 2009
programmer 	hugo
tested by	tobias

TC_S delivers the time it was last called on the output TC in seconds.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TC_S

(*Group:Default*)


VAR_OUTPUT
	TC :	REAL;
END_VAR


VAR
	init :	BOOL;
	tx :	UDINT;
	last :	UDINT;
	T_PLC_US :	T_PLC_US;
END_VAR


(*@KEY@: WORKSHEET
NAME: TC_S
IEC_LANGUAGE: ST
*)
(* read system time and prepare input data *)
T_PLC_US();
tx:= T_PLC_US.T_PLC_US;

IF NOT init THEN
	init := TRUE;
	TC := 0.0;
ELSE
	tc := UDINT_TO_REAL(tx - last) * 1.0E-6;
END_IF;
last := tx;

(* revision history
hm	13. mar. 2008	rev 1.0
	original version

hm	16. mar 2008	rev 1.1
	added type conversion to avoid warnings under codesys 3.0

hm	11. mar. 2009	rev 1.2
	changed real constants to use dot syntax

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
