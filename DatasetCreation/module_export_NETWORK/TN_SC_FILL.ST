(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TELNET_VISION
*)
(*@KEY@:DESCRIPTION*)
version 1.0		10. mai 2010
programmer		ks
tested by		ks

TN_SC_FILL füllt einen rechteckigen Bereich mit einem Zeichen

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_FILL

(*Group:lokal*)


VAR
	in_X :	INT;
	in_Y :	INT;
	in_Offset :	INT;
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
	Iin_Y1 :	INT;
	Iin_X1 :	INT;
	Iin_Y2 :	INT;
	Iin_X2 :	INT;
	Iby_CHAR :	BYTE;
	Iby_Attr :	BYTE;
END_VAR


VAR_IN_OUT
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
IF TN_SC_XY2_ERROR(Iin_X1,Iin_Y1,Iin_X2,Iin_Y2) THEN RETURN; END_IF;

FOR in_Y := Iin_Y1 TO Iin_Y2 DO
  Xus_TN_SCREEN.bya_Line_Update[in_Y] := TRUE; (* Zeile zum Updaten freigeben *)
  in_Offset := (in_Y * 80) + Iin_X1;
  FOR in_X := Iin_X1 TO Iin_X2 DO
    Xus_TN_SCREEN.bya_CHAR[in_Offset]  := Iby_CHAR; (* Zeichen eintragen *)
    Xus_TN_SCREEN.bya_COLOR[in_Offset] := Iby_Attr; (* Farbe eintragen *)
    in_Offset := in_Offset + 1;
  END_FOR;
END_FOR;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
