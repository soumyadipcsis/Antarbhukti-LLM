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
FUNCTION_BLOCK SETUP_MONTHS

(*Group:Default*)


VAR_IN_OUT
	MONTHS :	oscat_MONTHS;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_MONTHS
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;
init := TRUE;

(* ---- english --- *)
MONTHS[1][01] := 'January';
MONTHS[1][02] := 'February';
MONTHS[1][03] := 'March';
MONTHS[1][04] := 'April';
MONTHS[1][05] := 'May';
MONTHS[1][06] := 'June';
MONTHS[1][07] := 'July';
MONTHS[1][08] := 'August';
MONTHS[1][09] := 'September';
MONTHS[1][10] := 'October';
MONTHS[1][11] := 'November';
MONTHS[1][12] := 'December';

(* ---- german --- *)
MONTHS[2][01] := 'Januar';
MONTHS[2][02] := 'Februar';
MONTHS[2][03] := 'März';
MONTHS[2][04] := 'April';
MONTHS[2][05] := 'Mai';
MONTHS[2][06] := 'Juni';
MONTHS[2][07] := 'Juli';
MONTHS[2][08] := 'August';
MONTHS[2][09] := 'September';
MONTHS[2][10] := 'Oktober';
MONTHS[2][11] := 'November';
MONTHS[2][12] := 'Dezember';

(* ---- french --- *)
MONTHS[3][01] := 'Janvier';
MONTHS[3][02] := 'Février';
MONTHS[3][03] := 'mars';
MONTHS[3][04] := 'Avril';
MONTHS[3][05] := 'Mai';
MONTHS[3][06] := 'Juin';
MONTHS[3][07] := 'Juillet';
MONTHS[3][08] := 'Août';
MONTHS[3][09] := 'Septembre';
MONTHS[3][10] := 'Octobre';
MONTHS[3][11] := 'Novembre';
MONTHS[3][12] := 'Decembre';
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
