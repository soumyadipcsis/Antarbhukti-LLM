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
FUNCTION_BLOCK SETUP_MONTHS3

(*Group:Default*)


VAR_IN_OUT
	MONTHS3 :	oscat_MONTHS3;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_MONTHS3
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;
init := TRUE;

(* ---- english --- *)
MONTHS3[1][01] := 'Jan';
MONTHS3[1][02] := 'Feb';
MONTHS3[1][03] := 'Mar';
MONTHS3[1][04] := 'Apr';
MONTHS3[1][05] := 'May';
MONTHS3[1][06] := 'Jun';
MONTHS3[1][07] := 'Jul';
MONTHS3[1][08] := 'Aug';
MONTHS3[1][09] := 'Sep';
MONTHS3[1][10] := 'Oct';
MONTHS3[1][11] := 'Nov';
MONTHS3[1][12] := 'Dec';

(* ---- german --- *)
MONTHS3[2][01] := 'Jan';
MONTHS3[2][02] := 'Feb';
MONTHS3[2][03] := 'Mrz';
MONTHS3[2][04] := 'Apr';
MONTHs3[2][05] := 'Mai';
MONTHS3[2][06] := 'Jun';
MONTHS3[2][07] := 'Jul';
MONTHS3[2][08] := 'Aug';
MONTHS3[2][09] := 'Sep';
MONTHS3[2][10] := 'Okt';
MONTHS3[2][11] := 'Nov';
MONTHS3[2][12] := 'Dez';

(* ---- french --- *)
MONTHS3[3][01] := 'Jan';
MONTHS3[3][02] := 'Fev';
MONTHS3[3][03] := 'Mar';
MONTHS3[3][04] := 'Avr';
MONTHs3[3][05] := 'Mai';
MONTHS3[3][06] := 'Jun';
MONTHS3[3][07] := 'Jul';
MONTHS3[3][08] := 'Aou';
MONTHS3[3][09] := 'Sep';
MONTHS3[3][10] := 'Oct';
MONTHS3[3][11] := 'Nov';
MONTHS3[3][12] := 'Dec';
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
