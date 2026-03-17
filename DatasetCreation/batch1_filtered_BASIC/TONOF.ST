(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	21. jul 2009
programmer 	hugo
tested by	tobias

TONOF generated a TON and TOF Delay for the Input N TON (T1) and TOF (T2) can be configured separately

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TONOF

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	T_ON :	TIME;
	T_OFF :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	X :	TON;
	old :	BOOL;
	mode :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TONOF
IEC_LANGUAGE: ST
*)
IF IN XOR old THEN
  X(IN := FALSE, PT := SEL_TIME(IN,T_OFF,T_ON));
  mode := IN;
  old := IN;
END_IF;
X(IN := TRUE);
IF X.Q THEN Q := mode;END_IF;

(* revision history
hm	10. dec 2007	rev 1.0
	original version

hm	17. sep. 2007	rev 1.1
	improved performance

hm	21. jul. 2009	rev 1.2
	fixed a timing probelm


*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
