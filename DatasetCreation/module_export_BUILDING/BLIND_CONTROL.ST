(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: JALOUSIE
*)
(*@KEY@:DESCRIPTION*)
version 1.5		8. mar 2011
programmer 		AE
tested by		AE
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BLIND_CONTROL

(*Group:Default*)


VAR_INPUT
	UP :	BOOL;
	DN :	BOOL;
	S_IN :	BYTE;
	PI :	BYTE;
	AI :	BYTE;
	T_UD :	TIME;
	T_ANGLE :	TIME;
	SENS :	BYTE := 5;
	T_LOCKOUT :	TIME := T#100ms;
END_VAR


VAR_OUTPUT
	POS :	BYTE;
	ANG :	BYTE;
	MU :	BOOL;
	MD :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	act :	blind_actuator;
	delta :	BYTE;
	bTimeTest :	BOOL;
	iPos :	BYTE;
	iAngel :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: BLIND_CONTROL
IEC_LANGUAGE: ST
*)
IF bTimeTest THEN
	PI:=iPos;
	AI:=iAngel;
	UP:=TRUE;
	DN:=TRUE;
END_IF;

(* Check Position*)
act(T_UD:=T_UD, T_ANGLE:=T_ANGLE, T_lockout := T_Lockout);

IF UP AND DN THEN
	(* automatic modus detected *)
	(* first find correct position *)
	IF _BYTE_TO_INT(act.pos) < _BYTE_TO_INT(pi) - _BYTE_TO_INT(delta) THEN
		act.UP := TRUE;
		act.DN := FALSE;
		delta := BYTE#0;
		STATUS := BYTE#121;
	ELSIF _BYTE_TO_INT(act.pos) > _BYTE_TO_INT(pi) + _BYTE_TO_INT(delta) THEN
		act.UP := FALSE;
		act.DN := TRUE;
		delta := BYTE#0;
		STATUS := BYTE#122;
	(* regulate angle *)
	ELSIF _BYTE_TO_INT(act.ang) < _BYTE_TO_INT(ai) - _BYTE_TO_INT(delta) AND T_angle > T#100ms THEN
		act.UP := TRUE;
		act.DN := FALSE;
		delta := SHR(sens,2);
		STATUS := BYTE#123;
	ELSIF _BYTE_TO_INT(act.ang) > _BYTE_TO_INT(ai) + _BYTE_TO_INT(delta) AND T_angle > T#100ms THEN
		act.UP := FALSE;
		act.DN := TRUE;
		delta := SHR(sens,2);
		STATUS := BYTE#124;
	(* correct position reached *)
	ELSE
		act.UP := FALSE;
		act.DN := FALSE;
		delta := sens;
		STATUS := S_IN;
	END_IF;
ELSE
	act.UP := UP;
	act.DN := DN;
	STATUS := S_IN;
END_IF;

(* blind control calls blind_actuator *)
act(T_UD:=T_UD, T_ANGLE:=T_ANGLE, T_lockout := T_Lockout);
pos := act.pos;
ang := act.ang;
MU := act.QU;
md := act.QD;
status := act.status;

(* revision history
hm	29. sep 2007	rev 1.0
	original release

hm	6. oct 2007	rev 1.1
	rearranged outputs
	integrated blind_actuator into blind_control

hm	16. oct 2007	rev 1.2
	ignore angle when t_angle = 0

hm 29. oct 2007	rev 1.3
	added lockout configuration time for motor direction change
	sens has a setup value of 5

hm	27. jul. 2009	rev 1.4
	changed status handling

ae	08. mar. 2010	rev 1.5
	at aPosition bevor control
	at tolerance "delta := sens/2;"

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
