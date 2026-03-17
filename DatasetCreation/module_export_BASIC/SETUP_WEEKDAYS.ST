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
FUNCTION_BLOCK SETUP_WEEKDAYS

(*Group:Default*)


VAR_IN_OUT
	WEEKDAYS :	oscat_WEEKDAYS;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_WEEKDAYS
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;
init := TRUE;

(* ---- english --- *)
WEEKDAYS[1][01] := 'Monday';
WEEKDAYS[1][02] := 'Tuesday';
WEEKDAYS[1][03] := 'Wednesday';
WEEKDAYS[1][04] := 'Thursday';
WEEKDAYS[1][05] := 'Friday';
WEEKDAYS[1][06] := 'Saturday';
WEEKDAYS[1][07] := 'Sunday';

(* ---- german --- *)
WEEKDAYS[2][01] := 'Montag';
WEEKDAYS[2][02] := 'Dienstag';
WEEKDAYS[2][03] := 'Mittwoch';
WEEKDAYS[2][04] := 'Donnerstag';
WEEKDAYS[2][05] := 'Freitag';
WEEKDAYS[2][06] := 'Samstag';
WEEKDAYS[2][07] := 'Sonntag';

(* ---- french --- *)
WEEKDAYS[3][01] := 'Lundi';
WEEKDAYS[3][02] := 'Mardi';
WEEKDAYS[3][03] := 'Mercredi';
WEEKDAYS[3][04] := 'Jeudi';
WEEKDAYS[3][05] := 'Vendredi';
WEEKDAYS[3][06] := 'Samedi';
WEEKDAYS[3][07] := 'Dimanche';
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
