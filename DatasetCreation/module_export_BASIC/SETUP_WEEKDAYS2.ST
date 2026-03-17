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
FUNCTION_BLOCK SETUP_WEEKDAYS2

(*Group:Default*)


VAR_IN_OUT
	WEEKDAYS2 :	oscat_WEEKDAYS2;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_WEEKDAYS2
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;
init := TRUE;

(* ---- english --- *)
WEEKDAYS2[1][01] := 'Mo';
WEEKDAYS2[1][02] := 'Tu';
WEEKDAYS2[1][03] := 'We';
WEEKDAYS2[1][04] := 'Th';
WEEKDAYS2[1][05] := 'Fr';
WEEKDAYS2[1][06] := 'Sa';
WEEKDAYS2[1][07] := 'Su';

(* ---- german --- *)
WEEKDAYS2[2][01] := 'Mo';
WEEKDAYS2[2][02] := 'Di';
WEEKDAYS2[2][03] := 'Mi';
WEEKDAYS2[2][04] := 'Do';
WEEKDAYS2[2][05] := 'Fr';
WEEKDAYS2[2][06] := 'Sa';
WEEKDAYS2[2][07] := 'So';

(* ---- french --- *)
WEEKDAYS2[3][01] := 'Lu';
WEEKDAYS2[3][02] := 'Ma';
WEEKDAYS2[3][03] := 'Me';
WEEKDAYS2[3][04] := 'Je';
WEEKDAYS2[3][05] := 'Ve';
WEEKDAYS2[3][06] := 'Sa';
WEEKDAYS2[3][07] := 'Di';
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
