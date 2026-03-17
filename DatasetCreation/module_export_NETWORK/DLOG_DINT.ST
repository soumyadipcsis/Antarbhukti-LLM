(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DATA_LOG
*)
(*@KEY@:DESCRIPTION*)
version 1.2		25. jul. 2011
programmer		ks
tested by		ks

DLOG_DINT legt den DINT-Wert als STRING im FIFO-RING-Buffer ab um diesen mit den Baustein DLOG_STORE_* aufzuzeichnen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_DINT

(*Group:Default*)


VAR_INPUT
	VALUE :	DINT;
	COLUMN :	oscat_STRING40;
	DELTA :	DINT;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	ucb :	UNI_CIRCULAR_BUFFER;
	init :	BOOL;
	id :	WORD;
	delta_last :	DINT;
	value_last :	DINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_DINT
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	X.ID_MAX := X.ID_MAX + USINT#1;
	id := WORD#16#0801; (* Quelltype DINT, Zieltype STRING *)
END_IF;

IF X.ADD_HEADER THEN
	X.UCB.D_STRING := COLUMN;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
ELSIF X.ADD_DATA THEN
	X.UCB.D_STRING := DINT_TO_STRING(value_last,'%d');
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
	delta_last := value_last;
ELSIF DELTA <> DINT#0 THEN
	IF VALUE <= (delta_last - DELTA) OR VALUE >= (delta_last + DELTA) THEN
		X.ADD_DATA_REQ := TRUE;
		delta_last := VALUE;
	END_IF;
END_IF;
value_last := VALUE;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version

ks	17. may. 2011	rev 1.1
	DELTA Funktion integriert

ks	25. jul. 2011	rev 1.2
	neue head information
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
