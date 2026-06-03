(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 2.0	26. oct. 2008
programmer 	oscat
tested BY	oscat

this soft on/off ramp generator generates a soft on and soft off ramp while the max on value is set by the input
the time for a full ramp can be set by config variables for up and down ramp.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK RMP_SOFT

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	VAL :	BYTE;
	PT_ON :	TIME := T#100ms;
	PT_OFF :	TIME := T#100ms;
END_VAR


VAR_OUTPUT
	OUT :	BYTE := BYTE#00;
END_VAR


VAR
	rmp :	_RMP_B;
	tmp :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: RMP_SOFT
IEC_LANGUAGE: ST
*)
tmp := SEL(in, BYTE#0, val);
IF tmp > out THEN
	(* we need to ramp down *)
	rmp(dir := TRUE, E := TRUE, TR := PT_ON, RMP := out);
	out := rmp.RMP; 
	(* make sure out does not surpass tmp *)
	out := MIN(out, tmp);
ELSIF tmp < out THEN
	(* we need to ramp up *)
	rmp(dir := FALSE, E := TRUE, TR := PT_OFF, RMP := out);
	out := rmp.RMP; 
	(* make sure out does not surpass tmp *)
	out := MAX(out, tmp);
ELSE
	(* no ramp necessary *)
	rmp(E := FALSE, RMP := out);
	out := rmp.RMP; 
END_IF;


(* revision history

hm 22.1.2007	rev 1.1
	deleted unused variables X1 and I, X2 and X3

hm	17.9.2007	rev 1.2
	replaced time() with t_plc_ms() for compatibility reasons

hm	26. oct. 2008	2.0
	new code using _rmp_b
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
