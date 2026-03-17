(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	3. nov 2008
programmer 	hugo
tested by	oscat
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CTRL_OUT

(*Group:Default*)


VAR_INPUT
	CI :	REAL;
	OFFSET :	REAL;
	MAN_IN :	REAL;
	LIM_L :	REAL;
	LIM_H :	REAL;
	MANUAL :	BOOL;
END_VAR


VAR_OUTPUT
	Y :	REAL;
	LIM :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CTRL_OUT
IEC_LANGUAGE: ST
*)
Y := SEL(manual, CI, MAN_IN) + OFFSET;

(* Limit the output *)
IF Y >= LIM_H THEN
	Y := LIM_H;
	LIM := TRUE;
ELSIF Y <= lim_L THEN
	Y := LIM_L;
	LIM := TRUE;
ELSE
	LIM := FALSE;
END_IF;



(* revision history
hm 	2. jun. 2008 	rev 1.0
	original version

hm	3. nov. 2008	rev 1.1
	optimized code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
