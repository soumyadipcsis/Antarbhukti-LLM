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

DLOG_DT legt den formatierten DT String im FIFO-RING-Buffer ab um diesen mit den Baustein DLOG_STORE_*  aufzuzeichnen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DLOG_DT

(*Group:Default*)


VAR_INPUT
	FMT :	STRING := '#A-#D-#H #N:#R:#T';
	COLUMN :	oscat_STRING40;
	DELTA :	UDINT;
END_VAR


VAR_IN_OUT
	X :	oscat_DLOG_DATA;
END_VAR


VAR
	ucb :	UNI_CIRCULAR_BUFFER;
	init :	BOOL;
	id :	WORD;
	delta_last :	UDINT;
	DT_TO_STRF :	DT_TO_STRF;
END_VAR


(*@KEY@: WORKSHEET
NAME: DLOG_DT
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	X.ID_MAX := X.ID_MAX + USINT#1;
	id := WORD#16#0801; (* Quelltype DT, Zieltype STRING *)
END_IF;

IF X.ADD_HEADER THEN
	X.UCB.D_STRING := COLUMN;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
ELSIF X.ADD_DATA THEN
	DT_TO_STRF(DTI:=X.DTI,MS:=0,FMT:=FMT,LANG:=0);
	X.UCB.D_STRING := DT_TO_STRF.DT_TO_STRF;
	X.UCB.D_HEAD := id;
	X.UCB.D_MODE := 1;
	UCB(DATA:=X.UCB); (* Daten eintragen *)
    X.UCB := UCB.DATA;
	delta_last := X.DTI;
ELSIF DELTA <> UDINT#0 THEN
	IF X.DTI >= (delta_last + DELTA) THEN
		X.ADD_DATA_REQ := TRUE;
		delta_last := X.DTI;
	END_IF;
END_IF;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version

ks	17. may. 2011	rev 1.1
	COLUMN STRING(40), delta

ks	25. jul. 2011	rev 1.2
	neue head information

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
