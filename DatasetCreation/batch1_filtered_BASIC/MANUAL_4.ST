(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	17. jun 2008
programmer 	hugo
tested by	oscat

MANUAL_4 is a manual override for digital signals.
When MAN = FALSE, the output follows IN and when MAN = TRUE the Output follows M_I.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MANUAL_4

(*Group:Default*)


VAR_INPUT
	I0 :	BOOL;
	I1 :	BOOL;
	I2 :	BOOL;
	I3 :	BOOL;
	MAN :	BOOL;
	STP :	BOOL;
	M0 :	BOOL;
	M1 :	BOOL;
	M2 :	BOOL;
	M3 :	BOOL;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	edge :	BOOL;
	pos :	INT;
	tog :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MANUAL_4
IEC_LANGUAGE: ST
*)
IF man THEN
	IF NOT TOG THEN
		Q0 := M0;
		Q1 := M1;
		Q2 := M2;
		Q3 := M3;
		STATUS := BYTE#101;
	END_IF;
	IF STP AND NOT edge THEN
		tog := TRUE;
		CASE pos OF
			0:	Q0 := TRUE;
				Q1 := FALSE;
				Q2 := FALSE;
				Q3 := FALSE;
				STATUS := BYTE#110;
			1:	Q0 := FALSE;
				Q1 := TRUE;
				Q2 := FALSE;
				Q3 := FALSE;
				STATUS := BYTE#111;
			2:	Q0 := FALSE;
				Q1 := FALSE;
				Q2 := TRUE;
				Q3 := FALSE;
				STATUS := BYTE#112;
			3:	Q0 := FALSE;
				Q1 := FALSE;
				Q2 := FALSE;
				Q3 := TRUE;
				STATUS := BYTE#113;
		END_CASE;
		pos := INC(pos,1,3);
	END_IF;
ELSE
	Q0 := I0;
	Q1 := I1;
	Q2 := I2;
	Q3 := I3;
	STATUS := BYTE#100;
	tog := FALSE;
	pos := 0;
END_IF;

(* remember status of stp *)
edge := STP;



(* revision history
hm	17. jun 2008		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
