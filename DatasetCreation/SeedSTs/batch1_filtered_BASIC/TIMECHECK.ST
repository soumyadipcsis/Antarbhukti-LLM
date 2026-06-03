(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	19. jul. 2009
programmer 	oscat
tested by	oscat

this function retruns true if the daytime TD is between start and stop and returns true if so.
if you want to generate an event to span over midnight, start timemust be later than the stop time.

(*@KEY@:END_DESCRIPTION*)
FUNCTION TIMECHECK:BOOL

(*Group:Default*)


VAR_INPUT
	TD :	UDINT;
	START :	UDINT;
	STOP :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TIMECHECK
IEC_LANGUAGE: ST
*)
IF stop < start THEN
	TIMECHECK := start <= TD OR  TD < stop;
ELSE
	TIMECHECK := start <= TD AND TD < stop;
END_IF;

(* revision history
hm 19. jul. 2009	rev 1.0
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
