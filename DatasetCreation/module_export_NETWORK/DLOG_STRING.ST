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

DLOG_STRING legt den STRING im FIFO-RING-Buffer ab um diesen mit den Baustein DLOG_STORE_*  aufzuzeichnen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_STRING

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
	COLUMN :	oscat_STRING40;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	ucb :	UNI_CIRCULAR_BUFFER;
	init :	BOOL;
	id :	WORD;
	str_last :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_STRING
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	X.ID_MAX := X.ID_MAX + USINT#1;
	id := WORD#16#0101; (* Quelltype STRING, Zieltype STRING *)
END_IF;

IF X.ADD_HEADER THEN
	X.UCB.D_STRING := COLUMN;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
ELSIF X.ADD_DATA THEN
	X.UCB.D_STRING := str_last;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
END_IF;
str_last := STR;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version

ks	17. may. 2011	rev 1.1
	COLUMN STRING(40)

ks	25. jul. 2011	rev 1.2
neue head information

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
