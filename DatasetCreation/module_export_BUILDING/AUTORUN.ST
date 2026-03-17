(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ACTUATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	20. nov 2008
programmer 	hugo
tested by	oscat
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK AUTORUN

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	TEST :	BOOL;
	ARE :	BOOL := TRUE;
	TRUN :	TIME;
	TOFF :	TIME;
END_VAR


VAR_OUTPUT
	OUT :	BOOL;
	ARO :	BOOL;
END_VAR


VAR_IN_OUT
	ARX :	BOOL;
END_VAR


VAR
	timer :	_RMP_B;
	val :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: AUTORUN
IEC_LANGUAGE: ST
*)
(* run the integrator when T_off > T#0s *)
IF TOFF > T#0s THEN
	timer(DIR:= OUT, TR := SEL(OUT, TOFF, TRUN), RMP := val);
	val := timer.RMP;
ELSE
	val := BYTE#255;
END_IF;


(* when timer = 0 or test then initiate autorun until timer reaches 255 *)
IF (NOT ARX AND ARE AND val = BYTE#0) OR TEST THEN
	val := BYTE#0;
	ARO := TRUE;
	ARX := TRUE;
ELSIF val = BYTE#255 AND ARO THEN
	ARO := FALSE;
	ARX := FALSE;
END_IF;

(* output is true when autorun ARO is true or in = TRUE *)
out := IN OR ARO;



(* revision history
hm 20. nov. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
