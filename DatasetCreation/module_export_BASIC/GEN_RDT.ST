(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16 mar. 2008
programmer 	J. Schohaus
tested by	Hugo

RDMT generates a defined pulse with pulse width TP_Q at random times. the random time will be defined with an minimum and maximum time.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK GEN_RDT

(*Group:Default*)


VAR_INPUT
	ENABLE :	BOOL := TRUE;
	MIN_TIME_MS :	TIME := t#1s;(*min Taktzeit*)
	MAX_TIME_MS :	TIME := t#1.2s;(*Max Taktzeit*)
	TP_Q :	TIME := t#100ms;(*Zeit Ausgang auf TRUE*)
END_VAR


VAR_OUTPUT
	XQ :	BOOL;
END_VAR


VAR
	tonRDMTimer :	TON;(*Zeitbaustein Taktgenerator*)
	tof_xQ :	TOF;(*Ausschaltverzögerung Taktgenerator*)
	tRDMTime :	TIME;(*Sollzeit*)
	rRDMTime :	REAL;(*Zufallswert Timer*)
	rdm_1 :	rdm;
END_VAR


(*@KEY@: WORKSHEET
NAME: GEN_RDT
IEC_LANGUAGE: ST
*)
tonRDMTimer(IN:=Enable,PT:=tRDMTime);
tof_xQ(IN := tonRDMTimer.Q,PT:=TP_Q);
XQ := tof_xq.Q;
IF tonRDMTimer.Q THEN
	xQ := TRUE ;
    rdm_1(last:=rRDMTime);
    rRDMTime:= rdm_1.RDM;

	tRDMTime := REAL_TO_TIME(rRDMTime * TIME_TO_REAL(Max_Time_ms - Min_Time_ms) + TIME_TO_REAL(Min_Time_ms));
	tonRDMTimer (IN:=FALSE);
END_IF;

(* revision history
J. Schohaus	19. nov 2007	rev 1.0
	origial version

hm	16. mar. 2008			rev 1.1
	added type conversion to avoid warnings under codesys 3.0
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
