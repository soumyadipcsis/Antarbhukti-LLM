(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	21. oct. 2008
programmer 	hugo
tested by	oscat
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CTRL_PWM

(*Group:Default*)


VAR_INPUT
	CI :	REAL;
	MAN_IN :	REAL;
	MANUAL :	BOOL;
	F :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	PW :	PWM_DC;
END_VAR


(*@KEY@: WORKSHEET
NAME: CTRL_PWM
IEC_LANGUAGE: ST
*)
PW(F := F, DC := SEL(MANUAL,CI,MAN_IN));
Q := PW.Q;


(* revision history
hm 	3. jun. 2008 	rev 1.0
	original version

hm	21. oct. 2008	rev 1.1
	optimized code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
