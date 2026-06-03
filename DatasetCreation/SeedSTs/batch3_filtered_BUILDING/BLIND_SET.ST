(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: JALOUSIE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	27. jul 2009
programmer 	hugo
tested by	oscat

BLIND_SET can be used to force a definite position and angle.
blind_set can be placed close to blind_control for high priority while blind_input must be always at the beginning of the chain with low priority.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BLIND_SET

(*Group:Default*)


VAR_INPUT
	UP :	BOOL;
	DN :	BOOL;
	S_IN :	BYTE;
	PI :	BYTE;
	AI :	BYTE;
	IN :	BOOL;
	PX :	BYTE;
	AX :	BYTE;
	OVERRIDE_MANUAL :	BOOL;
	RESTORE_POSITION :	BOOL;
	RESTORE_TIME :	TIME := T#60s;
END_VAR


VAR_OUTPUT
	QU :	BOOL;
	QD :	BOOL;
	STATUS :	BYTE;
	PO :	BYTE;
	AO :	BYTE;
END_VAR


VAR
	T_PLC_MS :	T_PLC_MS;
	tx :	TIME;
	ps :	BYTE;
	as :	BYTE;
	last :	TIME;
END_VAR


(*@KEY@: WORKSHEET
NAME: BLIND_SET
IEC_LANGUAGE: ST
*)
(* read system Time *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* check inputs *)
IF IN THEN
	IF override_manual OR (UP AND DN) THEN
		status := 178;
	END_IF;
END_IF;

(* state machine *)
CASE STATUS OF
	0: (* power on state *)
		status := S_IN;

	178: (* force values from PX and AX *)
		PO := PX;
		AO := AX;
		QU := TRUE;
		QD := TRUE;
		(* check for end of forced position *)
		IF NOT in THEN
			STATUS := SEL(RESTORE_POSITION, S_IN, 179);
			last := tx;
		END_IF;

	179: (* restore previous position *)
		PO := ps;
		AO := as;
		IF ((PO = PI) AND (AO = AI))  OR tx - last >= RESTORE_TIME THEN
			status := S_IN;
		END_IF;

ELSE
	(* no operation transfer inputs to outputs *)
	PO := PI;
	ps := PI;
	AO := AI;
	as := AI;
	STATUS := S_IN;
	QU := UP;
	QD := DN;
END_CASE;


(* revision history
hm	27. jul 2009	rev 1.0
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
