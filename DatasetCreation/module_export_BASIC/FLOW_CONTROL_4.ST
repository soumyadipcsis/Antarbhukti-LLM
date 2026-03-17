(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	19. jun 2008
programmer 	hugo
tested by	oscat

FLOW_CONTROL switches up to 4 valves depending on the 4 inputs i and generates a safety valve signal.
flow control also limits the maximum ontime of valves and controls pressure on the output side.
a diangnostic mode can automatically check all valves for operation and report errors.
anti freeze can be used to protect valves from icing during cold season´.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FLOW_CONTROL_4

(*Group:Default*)


VAR_INPUT
	I0 :	BOOL;
	I1 :	BOOL;
	I2 :	BOOL;
	I3 :	BOOL;
	PR :	BOOL;
	ICE :	BOOL;
	DIAG :	BOOL;
	ENQ :	BOOL;
	RST :	BOOL := FALSE;
	TD_WAIT :	TIME := T#5s;
	TD_S :	TIME := T#10s;
	TD_0 :	TIME := T#10s;
END_VAR


VAR_OUTPUT
	QS :	BOOL;
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	ERROR :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	state :	INT;
	timer :	TP;
END_VAR


(*@KEY@: WORKSHEET
NAME: FLOW_CONTROL_4
IEC_LANGUAGE: ST
*)
IF RST THEN
	STATUS := BYTE#100;
	state := 0;
	error := FALSE;

ELSIF DIAG THEN
	(* diag puts pressure by opening QS for TD_wait,
	thencloses all valves and waits for td_wait, opens valve_0 and checks pressure after td_0
	if pressure is too low, an error is present.
	continue the same procedure for all valves *)
	CASE state OF
		0 : (* start diag operation *)
			(* close all valves and pressurize the system *)
			QS := TRUE;
			Q0 := FALSE;
			Q1 := FALSE;
			Q2 := FALSE;
			Q3 := FALSE;
			timer(in := TRUE, pt := TD_WAIT);
			timer.IN := FALSE;
			state := 1;
		1 : (* wait for TD_wait *)
			timer();
			IF NOT timer.Q THEN
				QS := FALSE;
				timer(in := TRUE, pt := TD_S);
				timer.IN := FALSE;
				state := 2;
			END_IF;
		2:	(* wait for safety valve pressure test *)
			timer();
			IF NOT timer.Q THEN
				IF NOT pr THEN
					(* system pressure failure *)
					ERROR := TRUE;
					STATUS := BYTE#1;
					RETURN;
				END_IF;
				timer(in := TRUE, pt := TD_0);
				timer.IN := FALSE;
				Q0 := TRUE;
				state := 3;
			END_IF;
		3:	(* wait for pressure on Q0 to hold TD_0 *)
			timer();
			IF NOT timer.Q THEN
				IF NOT pr THEN
					(* valve 0 pressure failure *)
					ERROR := TRUE;
					STATUS := BYTE#1;
					RETURN;
				END_IF;
				Q0 := FALSE;
				QS := TRUE;
			END_IF;
	END_CASE;
ELSIF ICE THEN
	(* when frost is present we close the safety valve and open all other valves to depressurize the valves *)
	QS := FALSE;
	Q0 := TRUE;
	Q1 := TRUE;
	Q2 := TRUE;
	Q3 := TRUE;
	STATUS := BYTE#110;

ELSIF NOT error AND ENQ THEN
		Q0 := I0;
		Q1 := I1;
		Q2 := I2;
		Q3 := I3;
		QS := Q0 OR Q1 OR Q2 OR Q3;
		STATUS := BYTE#100;

		(* maximum ontime check *)
ELSE
	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
END_IF;

(* revision history
hm 	19. jun. 2008 	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
