(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: JALOUSIE
*)
(*@KEY@:DESCRIPTION*)
version 1.2	12. feb 2008
programmer 	hugo
tested by	tobias
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BLIND_SECURITY

(*Group:Default*)


VAR_INPUT
	UP :	BOOL;
	DN :	BOOL;
	S_IN :	BYTE;
	PI :	BYTE;
	AI :	BYTE;
	FIRE :	BOOL;
	WIND :	BOOL;
	ALARM :	BOOL;
	DOOR :	BOOL;
	RAIN :	BOOL;
	ALARM_UP :	BOOL := TRUE;
	WIND_UP :	BOOL := TRUE;
	RAIN_UP :	BOOL := TRUE;
END_VAR


VAR_OUTPUT
	QU :	BOOL;
	QD :	BOOL;
	STATUS :	BYTE;
	PO :	BYTE;
	AO :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: BLIND_SECURITY
IEC_LANGUAGE: ST
*)
IF Fire THEN
	QU := TRUE;
	QD := FALSE;
	status := BYTE#111;
ELSIF Wind THEN
	QU := Wind_up;
	QD := NOT wind_up;
	status := BYTE#112;
ELSIF alarm THEN
	QU := Alarm_up;
	QD := NOT Alarm_up;
	status := BYTE#113;
ELSIF Door THEN
	QU := TRUE;
	QD := FALSE;
	status := BYTE#114;
ELSIF Rain AND NOT (up XOR dn) THEN
	QU := rain_up;
	QD := NOT rain_up;
	status := BYTE#115;
ELSE
	QU := UP;
	QD := DN;
	status := S_IN;
	po := pi;
	ao := ai;
END_IF;


(* revision history
hm	29. sep 2007	rev 1.0
	original release

hm	6. oct 2007		rev 1.1
	added pos and angle inputs and outputs
	manual will override rain position
	alarm position can now be configured

hm		12. feb. 2008	rev 1.2
	added config variables rain_up and wind_up
	position for rain and wind is now configurable
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
