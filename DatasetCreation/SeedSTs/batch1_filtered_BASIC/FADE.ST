(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.3	24. jan. 2009
programmer 	oscat
tested BY	oscat

FADE is used to crossfade between the inputs IN1 and IN2. The fade_over time is specified with TF.
When F = TRUE then Y = IN2 after the time TF, and when F = FALSE then Y = IN1.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FADE

(*Group:Default*)


VAR_INPUT
	IN1 :	REAL;
	IN2 :	REAL;
	F :	BOOL;
	TF :	TIME;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Y :	REAL;
END_VAR


VAR
	rmx :	RMP_W;
END_VAR


(*@KEY@: WORKSHEET
NAME: FADE
IEC_LANGUAGE: ST
*)
rmx(rst := rst AND NOT F, set := rst AND F, pt := TF, up := F);
Y := (in2 - In1) / 65535.0 * _WORD_TO_REAL(rmx.out) + in1;

(* revision history
hm	26. dec 2007	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	improved performance
	changed calls for rmp_w because rmp_w has chaged

hm	17. dec. 2008	rev 1.2
	function of input f was inverted

hm	24. jan. 2009	rev 1.3
	delted unused var FF
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
