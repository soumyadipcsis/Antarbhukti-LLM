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

TN_SC_WRITE schreibt einem Text an die angegebene Koordinate

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_WRITE

(*Group:instances*)


VAR
	CODE :	CODE;
END_VAR


(*Group:lokal*)


VAR
	bo_Color :	BOOL;
	in_Offset :	INT;
	in_Char_Index :	INT;
	in_String_Length :	INT;
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
	Iin_Y :	INT;
	Iin_X :	INT;
	Iby_ATTR :	BYTE;
	Ist_STRING :	STRING;
END_VAR


VAR_IN_OUT
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
in_String_Length := LEN(Ist_STRING);
IF TN_SC_XY_ERROR(Iin_X + in_String_Length - 1,Iin_Y) THEN RETURN; END_IF;
Xus_TN_SCREEN.bya_Line_Update[Iin_Y] := TRUE; (* Zeile zum Updaten freigeben *)
in_Offset := (Iin_Y * 80) + Iin_X; (* Offset des ersten Zeichen berechnen *)
bo_Color := Iby_ATTR <> BYTE#00;

(* -----------------------------------------------------------------*)
(* Zeichen und Attribute des String kopieren                        *)
(* -----------------------------------------------------------------*)

FOR in_Char_Index := 1 TO in_String_Length DO

  IF bo_Color THEN Xus_TN_SCREEN.bya_COLOR[in_Offset] := Iby_ATTR; END_IF;

  CODE(STR:=Ist_STRING,POS:=in_Char_Index);
  Xus_TN_SCREEN.bya_CHAR[in_Offset] := CODE.CODE;
  in_Offset := in_Offset + INT#1;

END_FOR;

(* End of String Offset sichern *)
Xus_TN_SCREEN.in_EOS_Offset := in_Offset;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
