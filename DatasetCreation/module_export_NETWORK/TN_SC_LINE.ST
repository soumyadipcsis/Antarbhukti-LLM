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

TN_SC_LINE zeichnet horizontale und vertikale Linien

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_LINE

(*Group:instances*)


(*Group:lokal*)


VAR
	by_Connect_Left_Char :	BYTE;
	by_Connect_Right_Char :	BYTE;
	by_Connect_Top_Char :	BYTE;
	by_Connect_Bottom_Char :	BYTE;
	by_Connect_Cruz_Char :	BYTE;
	by_Vertikal_Line_Char :	BYTE;
	by_Horzontal_Line_Char :	BYTE;
	by_old_Char :	BYTE;
	in_Offset_1 :	INT;
	in_ROW_Index :	INT;
	in_COL_Index :	INT;
	by_Char :	BYTE;
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
	Iin_X1 :	INT;
	Iin_Y1 :	INT;
	Iin_X2 :	INT;
	Iin_Y2 :	INT;
	Iby_ATTR :	BYTE;
	Iby_BORDER :	BYTE;
END_VAR


VAR_IN_OUT
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
IF TN_SC_XY2_ERROR(Iin_X1,Iin_Y1,Iin_X2,Iin_Y2) THEN RETURN; END_IF;

(* Bordertype bestimmen  *)
IF Iby_Border = BYTE#01 THEN

  (* Single Line           *)
  by_Connect_Top_Char    := BYTE#16#C2;
  by_Connect_Bottom_Char := BYTE#16#C1;
  by_Connect_Left_Char   := BYTE#16#C3;
  by_Connect_Right_Char  := BYTE#16#B4;
  by_Horzontal_Line_Char := BYTE#16#C4;
  by_Vertikal_Line_Char  := BYTE#16#B3;
  by_Connect_Cruz_Char   := BYTE#16#C5;

ELSIF Iby_Border = BYTE#02 THEN

  (* Double Linie          *)
  by_Connect_Top_Char    := BYTE#16#CB;
  by_Connect_Bottom_Char := BYTE#16#CA;
  by_Connect_Left_Char   := BYTE#16#CC;
  by_Connect_Right_Char  := BYTE#16#B9;
  by_Horzontal_Line_Char := BYTE#16#CD;
  by_Vertikal_Line_Char  := BYTE#16#BA;
  by_Connect_Cruz_Char   := BYTE#16#CE;

ELSE
  (* Full Linie              *)
  by_Connect_Top_Char    := Iby_Border;
  by_Connect_Bottom_Char := Iby_Border;
  by_Connect_Left_Char   := Iby_Border;
  by_Connect_Right_Char  := Iby_Border;
  by_Horzontal_Line_Char := Iby_Border;
  by_Vertikal_Line_Char  := Iby_Border;
  by_Connect_Cruz_Char   := Iby_Border;

END_IF;

(* -----------------------------------------------------------------*)
(* Vertikale Linie zeichnen                                         *)
(* -----------------------------------------------------------------*)
IF Iin_X1 = Iin_X2 THEN

  in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;

  FOR in_ROW_Index := Iin_Y1 TO Iin_Y2 DO

    (* bestehendes Zeichen auslesen *)
    by_old_Char := Xus_TN_SCREEN.bya_CHAR[in_Offset_1];

    (* Standardzeichen vorbelegen *)
    by_Char := by_Vertikal_Line_Char;

    (* Schnittpunkt erkannt *)
    IF by_old_Char = by_Horzontal_Line_Char THEN

      (* Anfang der Linie behandeln *)
      IF in_ROW_Index = Iin_Y1 THEN
        by_Char := by_Connect_Top_Char;
  
      (* Ende der Linie behandeln *)
      ELSIF in_ROW_Index = Iin_Y2 THEN
        by_Char := by_Connect_Bottom_Char; 
    
      (* Kreuzungspunkt behandeln *)
      ELSE 
        by_Char := by_Connect_Cruz_Char; 
      END_IF;

    END_IF;

    (* Zeile zum Updaten freigeben *)
    Xus_TN_SCREEN.bya_Line_Update[in_ROW_Index] := TRUE;

    Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_Char;
    Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

    in_Offset_1 := in_Offset_1 + 80;

  END_FOR;

(* -----------------------------------------------------------------*)
(* Horzontale Linie zeichnen                                         *)
(* -----------------------------------------------------------------*)
ELSIF Iin_Y1 = Iin_Y2 THEN

  (* Zeile zum Updaten freigeben *)
  Xus_TN_SCREEN.bya_Line_Update[Iin_Y1] := TRUE;

  in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;

  FOR in_COL_Index := Iin_X1 TO Iin_X2 DO

    (* bestehendes Zeichen auslesen *)
    by_old_Char := Xus_TN_SCREEN.bya_CHAR[in_Offset_1];

    (* Standardzeichen vorbelegen *)
    by_Char := by_Horzontal_Line_Char;

    (* Schnittpunkt erkannt *)
    IF by_old_Char = by_Vertikal_Line_Char THEN

      (* Anfang der Linie behandeln *)
      IF in_COL_Index = Iin_X1 THEN
        by_Char := by_Connect_Left_Char;
  
      (* Ende der Linie behandeln *)
      ELSIF in_COL_Index = Iin_X2 THEN
        by_Char := by_Connect_Right_Char; 
    
      (* Kreuzungspunkt behandeln *)
      ELSE 
        by_Char := by_Connect_Cruz_Char; 
      END_IF;

    END_IF;

    Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_Char;
    Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

    in_Offset_1 := in_Offset_1 + 1;

  END_FOR;
END_IF;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
