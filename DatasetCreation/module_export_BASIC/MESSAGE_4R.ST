(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	27. oct. 2008
programmer 	hugo
tested by	tobias

this function generates a rotation meassage with up to 4 strings.
on each rising edge of EN the next message in line will be displayed.
when EN stays high longer then one cycle, the next message will be displayed automatically after the time T1 is elapsed.
the output MX is the generated message and CX is a counter 0..3 signaling the current message displayed.
the displayed messages are 0 .. MM.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MESSAGE_4R

(*Group:Default*)


VAR_INPUT
	M0 :	STRING;
	M1 :	STRING;
	M2 :	STRING;
	M3 :	STRING;
	MM :	INT := 3;
	ENQ :	BOOL := TRUE;
	CLK :	BOOL := TRUE;
	T1 :	TIME := T#3s;
END_VAR


VAR_OUTPUT
	MX :	STRING;
	MN :	INT;
	TR :	BOOL;
END_VAR


VAR
	timer :	TON;
	edge :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MESSAGE_4R
IEC_LANGUAGE: ST
*)
(* check for rising edge on EN *)
TR := FALSE;
IF ENQ THEN
	IF (NOT edge AND clk) OR timer.q THEN
			MN := INC1(MN, MM);
			TR := TRUE;
			timer(in := FALSE);
			CASE MN OF
				0 : MX := M0;
				1 : MX := M1;
				2 : MX := M2;
				3 : MX := M3;
			END_CASE;
	END_IF;
	edge := clk;
	timer( in := CLK, pt := T1);
ELSE
	MX := '';
	MN := 0;
END_IF;

(* revision history
hm	8. oct. 2008	rev 1.0
	original version

hm	27. oct. 2008	rev 1.1
	changed _INC to INC1

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
