(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DATA_LOG
*)
(*@KEY@:DESCRIPTION*)
version 1.1		25. jul. 2011
programmer		ks
tested by		ks

DLOG_BOOL legt den ON/OFF Text im FIFO-RING-Buffer ab um diesen mit den Baustein DLOG_STORE_*  aufzuzeichnen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_BOOL

(*Group:Default*)


VAR_INPUT
	STATE :	BOOL;
	OFF :	STRING;
	ON :	STRING;
	COLUMN :	oscat_STRING40;
	DELTA :	BOOL;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	ucb :	UNI_CIRCULAR_BUFFER;
	init :	BOOL;
	id :	WORD;
	last_delta :	BOOL;
	state_last :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_BOOL
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	X.ID_MAX := X.ID_MAX + USINT#1;
	id := WORD#16#0601; (* Quelltype BOOL, Zieltype STRING *)
END_IF;

IF X.ADD_HEADER THEN
	X.UCB.D_STRING := COLUMN;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
ELSIF X.ADD_DATA THEN
	X.UCB.D_STRING := SEL_STRING(state_last,OFF,ON);
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
	last_delta := STATE;
ELSIF DELTA AND (STATE XOR last_delta) THEN
	X.ADD_DATA_REQ := TRUE;
	last_delta := STATE;
END_IF;
state_last := STATE;

(* revision history
ks	17. may. 2011	rev 1.0
	original version

ks	25. jul. 2011	rev 1.1
	neue head information

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
