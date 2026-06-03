(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: JALOUSIE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. jan 2008
programmer 	hugo
tested by	tobias
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BLIND_SCENE

(*Group:Default*)


VAR_INPUT
	UP :	BOOL;
	DN :	BOOL;
	S_IN :	BYTE;
	PI :	BYTE;
	AI :	BYTE;
	ENABLE :	BOOL;
	SWRITE :	BOOL;
	SCENE :	BYTE;
END_VAR


VAR_OUTPUT
	QU :	BOOL;
	QD :	BOOL;
	STATUS :	BYTE;
	PO :	BYTE;
	AO :	BYTE;
END_VAR


VAR
	x :	INT;
END_VAR


VAR RETAIN 
	sx :	oscat_blind_scene_array;
END_VAR


(*@KEY@: WORKSHEET
NAME: BLIND_SCENE
IEC_LANGUAGE: ST
*)
(* delete all bits except the lower 4 of scene *)
x := _BYTE_TO_INT(scene AND BYTE#2#0000_1111);

IF enable AND (sx[x][2] > BYTE#0) AND UP AND DN THEN
	po := sx[x][0];
	ao := sx[x][1];
	status := INT_TO_BYTE(160 + x);  (* Status number is 160 to 175 for the 16 scenes *)
	QU := TRUE;
	QD := TRUE;
ELSE
	QU := UP;
	QD := DN;
	status := S_IN;
	po := pi;
	ao := ai;
END_IF;

(* write scene if necessary *)
IF swrite THEN
	status := BYTE#176;		(* write scene *)
	sx[x][0] := pi;
	sx[x][1] := ai;
	IF enable THEN sx[x][2] := BYTE#1; ELSE sx[x][2] := BYTE#0; END_IF; (* if sx[x][2] = 0 the scene is disabled *)
END_IF;

(* revision history
hm	24. oct 2007	rev 1.0
	original release

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
