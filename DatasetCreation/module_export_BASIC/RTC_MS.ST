(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. feb. 2008
programmer 	hugo
tested by	tobias

RTC_MS is a real time clock module which can be set to SDT when set is TRUE and the outputs XDT and XT present the DateTime and TOD with a resolution of milliseconds.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK RTC_MS

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	SDT :	UDINT;
	SMS :	INT;
END_VAR


VAR_OUTPUT
	XDT :	UDINT;
	XMS :	INT;
END_VAR


VAR
	init :	BOOL;
	last :	UDINT;
	tx :	UDINT;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: RTC_MS
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

IF set OR NOT init THEN
	(* clock needs to be set when set is true or after power up *)
	init := TRUE;
	xdt := SDT;
	XMS := SMS;
ELSE
	XMS := XMS + UDINT_TO_INT(tx - last);
	(* check if one second has expired *)
	IF XMS > 999 THEN
		XDT := XDT + UDINT#1; (* add one second *)
		XMS := XMS - 1000;
	END_IF;
END_IF;
last := tx;


(* revision history
hm		20. jan. 2008	rev 1.0
	original version

hm		20. feb. 2008	rev 1.1
	added Millisecond Set input
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
