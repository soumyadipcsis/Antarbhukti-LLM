(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: WEATHER
*)
(*@KEY@:DESCRIPTION*)
(*
version 1.0		15. may. 2011
programmer		ks
tested by		ks

MOON_PHASE berechnet die aktuelle Mondphase
*)
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MOON_PHASE

(*Group:Default*)


VAR_INPUT
	XDT :	UDINT;
	SCALE :	BYTE := BYTE#12;
	UPDATE :	TIME := T#1h;
END_VAR


VAR_OUTPUT
	PHASE :	BYTE;
END_VAR


VAR
	x :	UDINT;
	last_dt :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MOON_PHASE
IEC_LANGUAGE: ST
*)
IF XDT - last_dt > TIME_TO_UDINT(UPDATE) THEN
	x := (XDT - UDINT#603240) MOD UDINT#2551392;
	PHASE := UDINT_TO_BYTE(BYTE_TO_UDINT(SCALE) * x / UDINT#2551392) ;
	last_dt := XDT;
END_IF;

(* revision history
ks	15.may. 2011	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
