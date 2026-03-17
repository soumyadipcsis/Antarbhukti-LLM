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

DLOG_REAL legt den REAL-Wert als STRING im FIFO-RING-Buffer ab um diesen mit den Baustein DLOG_STORE_*  aufzuzeichnen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_REAL

(*Group:Default*)


VAR_INPUT
	VALUE :	REAL;
	N :	INT;
	D :	oscat_STRING1 := ',';
	COLUMN :	oscat_STRING40;
	DELTA :	REAL;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	ucb :	UNI_CIRCULAR_BUFFER;
	init :	BOOL;
	id :	WORD;
	REAL_TO_STRF :	REAL_TO_STRF;
	delta_last :	REAL;
	value_last :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_REAL
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	X.ID_MAX := X.ID_MAX + USINT#1;
	id := SHL(USINT_TO_WORD(X.ID_MAX),8) OR WORD#1;
	id := WORD#16#0201; (* Quelltype REAL, Zieltype STRING *)
END_IF;

IF X.ADD_HEADER THEN
	X.UCB.D_STRING := COLUMN;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
ELSIF X.ADD_DATA THEN
    REAL_TO_STRF(IN:=value_last,N:=N,D:=D);
    X.UCB.D_STRING:=REAL_TO_STRF.REAL_TO_STRF;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
	delta_last := value_last;
ELSIF DELTA <> 0.0 THEN
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
