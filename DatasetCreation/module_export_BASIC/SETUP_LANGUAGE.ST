(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: SETUP
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SETUP_LANGUAGE

(*Group:Default*)


VAR_IN_OUT
	LANGUAGE :	oscat_LANGUAGE;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_LANGUAGE
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;
init := TRUE;

LANGUAGE.DEFAULT  := 1; (* 1=english, 2=german 3=french *)
LANGUAGE.LMAX := 3;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
