(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TELNET_VISION
*)
(*@KEY@:DESCRIPTION*)
version 1.1		06. apr 2011
programmer		ks
tested by		ks

TN_MENU_POPUP dient zur verwaltung und darstellung eines MENU-POPUP

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_INPUT_MENU_POPUP

(*Group:instances*)


VAR
	FB_TN_SC_AREA_SAVE :	TN_SC_AREA_SAVE;
	FB_TN_SC_AREA_RESTORE :	TN_SC_AREA_RESTORE;
	FB_TN_SC_LINE :	TN_SC_LINE;
	FB_TN_SC_ADD_SHADOW :	TN_SC_ADD_SHADOW;
	FB_TN_SC_BOX :	TN_SC_BOX;
	FB_TN_SC_WRITE_C :	TN_SC_WRITE_C;
	ELEMENT_COUNT :	ELEMENT_COUNT;
	ELEMENT_GET :	ELEMENT_GET;
END_VAR


(*Group:lokal*)


VAR
	in_ROW :	INT;
	in_ROWS :	INT;
	in_COL :	INT;
	in_COLS :	INT;
	in_index :	INT;
	in_Count :	INT;
	in_Scroll_Offset :	INT;
	by_ATTR :	BYTE;
END_VAR


(*Group:IN_OUT*)


VAR_IN_OUT
	Xus_TN_MENU_POPUP :	us_TN_MENU_POPUP;
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


(*@KEY@: WORKSHEET
NAME: TN_INPUT_MENU_POPUP
IEC_LANGUAGE: ST
*)
(* sicherstellen das rechteck immer innerhalb screen positioniert wird *)

IF (Xus_TN_MENU_POPUP.bo_Activ = FALSE) AND (Xus_TN_MENU_POPUP.bo_Create = TRUE) THEN
  Xus_TN_MENU_POPUP.bo_Activ         := TRUE;
  Xus_TN_MENU_POPUP.bo_Create        := FALSE;
  Xus_TN_MENU_POPUP.bo_Destroy       := FALSE;
  Xus_TN_MENU_POPUP.bo_Update        := TRUE;

  (* -----------------------------------------------------------------*)
  (* Sub-Menu-Texte                                                   *)
  (* -----------------------------------------------------------------*)

  ELEMENT_COUNT(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35);
  Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_COUNT.ELEMENT;
  Xus_TN_MENU_POPUP.in_Menu_E_Count:=ELEMENT_COUNT.ELEMENT_COUNT;

  (* -----------------------------------------------------------------*)
  (* Anzahl Zeilen (Sub-Menu-Texte) bestimmen                         *)
  (* -----------------------------------------------------------------*)
  Xus_TN_MENU_POPUP.in_Rows := Xus_TN_MENU_POPUP.in_Menu_E_Count;

  (* -----------------------------------------------------------------*)
  (* längsten Sub-Menu-Text suchen                                    *)
  (* -----------------------------------------------------------------*)
  Xus_TN_MENU_POPUP.in_Cols := INT#00;

  FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Rows DO;

    ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_Count-1);
    Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;
    Xus_TN_MENU_POPUP.in_Cols:=MAX_INT(LEN(ELEMENT_GET.ELEMENT_GET),Xus_TN_MENU_POPUP.in_Cols);

  END_FOR;

  (* -----------------------------------------------------------------*)
  (* Horizontale Position überprüfen und korrigieren                  *)
  (* -----------------------------------------------------------------*)
  IF (Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols) > INT#75 THEN
    Xus_TN_MENU_POPUP.in_X := INT#79 - Xus_TN_MENU_POPUP.in_Cols - INT#04;
  END_IF;

  (* -----------------------------------------------------------------*)
  (* Vertikale Position überprüfen und korrigieren                    *)
  (* -----------------------------------------------------------------*)
  IF (Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_ROWS) > INT#21 THEN
    Xus_TN_MENU_POPUP.in_Y := INT#23 - Xus_TN_MENU_POPUP.in_ROWS - INT#2;
  END_IF;

  Xus_TN_SCREEN.bo_Modal_Dialog := TRUE;

  (* -----------------------------------------------------------------*)
  (* Hintergrund sichern                                              *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_AREA_SAVE.Iin_X1        := Xus_TN_MENU_POPUP.in_X;
  FB_TN_SC_AREA_SAVE.Iin_Y1        := Xus_TN_MENU_POPUP.in_Y;
  FB_TN_SC_AREA_SAVE.Iin_X2        := Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols + INT#04;
  FB_TN_SC_AREA_SAVE.Iin_Y2        := Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_Rows + INT#02;
  FB_TN_SC_AREA_SAVE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_AREA_SAVE();
  Xus_TN_SCREEN := FB_TN_SC_AREA_SAVE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Rahmen für Submenu zeichnen                                      *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_BOX.Iin_X1        := Xus_TN_MENU_POPUP.in_X;
  FB_TN_SC_BOX.Iin_Y1        := Xus_TN_MENU_POPUP.in_Y;
  FB_TN_SC_BOX.Iin_X2        := Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols + INT#03;
  FB_TN_SC_BOX.Iin_Y2        := Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_Rows + INT#01;
  FB_TN_SC_BOX.Iby_FILL      := BYTE#32;         (* Füllung            *)
  FB_TN_SC_BOX.Iin_BORDER    := INT#01;          (* Single-Line Border *)
  FB_TN_SC_BOX.Iby_ATTR      := Xus_TN_MENU_POPUP.by_Attr_oF;
  FB_TN_SC_BOX.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_BOX();
  Xus_TN_SCREEN := FB_TN_SC_BOX.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Shadow für Submenu zeichnen                                      *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_ADD_SHADOW.Iin_X1        := Xus_TN_MENU_POPUP.in_X + INT#1;
  FB_TN_SC_ADD_SHADOW.Iin_Y1        := Xus_TN_MENU_POPUP.in_Y + INT#1;
  FB_TN_SC_ADD_SHADOW.Iin_X2        := Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols + INT#04;
  FB_TN_SC_ADD_SHADOW.Iin_Y2        := Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_Rows + INT#02;
  FB_TN_SC_ADD_SHADOW.Iin_OPTION    := INT#00;
  FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_ADD_SHADOW();
  Xus_TN_SCREEN := FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Parameter laden                                                  *)
  (* -----------------------------------------------------------------*)
  in_COL  := Xus_TN_MENU_POPUP.in_X;
  in_ROW  := Xus_TN_MENU_POPUP.in_Y;
  in_ROWS := Xus_TN_MENU_POPUP.in_Rows;
  in_COLS := Xus_TN_MENU_POPUP.in_Cols;

  (* -----------------------------------------------------------------*)
  (* Trennlinien zeichnen                                             *)
  (* -----------------------------------------------------------------*)
  in_COLS := in_COLS + INT#02;    (* Text um 2 Zeichen verlängern *)

  FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Menu_E_Count DO;
    in_ROW := in_ROW + INT#01;
  
    ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_Count-1);
	Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

    IF EQ_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN

      FB_TN_SC_LINE.Iin_Y1			:= in_ROW;
      FB_TN_SC_LINE.Iin_X1			:= in_COL;
      FB_TN_SC_LINE.Iin_Y2			:= in_ROW;
      FB_TN_SC_LINE.Iin_X2			:= in_COL + in_COLS + INT#01;
      FB_TN_SC_LINE.Iby_ATTR		:= Xus_TN_MENU_POPUP.by_Attr_oF;
      FB_TN_SC_LINE.Iby_BORDER		:= BYTE#01;
      FB_TN_SC_LINE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
      FB_TN_SC_LINE();
      Xus_TN_SCREEN := FB_TN_SC_LINE.Xus_TN_SCREEN;

    END_IF;
  END_FOR;
END_IF;

IF (Xus_TN_MENU_POPUP.bo_Activ = TRUE) THEN

  CASE _BYTE_TO_INT(Xus_TN_MENU_POPUP.by_Input_Exten_Code) OF

  65: (* Cursor oben *)
    in_Scroll_Offset := INT#-1;
    Xus_TN_MENU_POPUP.bo_Update := TRUE;

  66: (* Cursor unten *)
    in_Scroll_Offset := INT#1;
    Xus_TN_MENU_POPUP.bo_Update := TRUE;

  13:  (* Enter *)
    Xus_TN_MENU_POPUP.bo_Destroy := TRUE;

  27:  (* Escape*)
    Xus_TN_MENU_POPUP.bo_Destroy := TRUE;
    Xus_TN_MENU_POPUP.in_Cur_Item := INT#00;

  67..68:  (* Cursor links oder rechts *)
    Xus_TN_MENU_POPUP.bo_Destroy := TRUE;
    Xus_TN_MENU_POPUP.in_Cur_Item := INT#00;

  END_CASE;

END_IF;

(* -----------------------------------------------------------------*)
(* POPUP-Menu updaten                                               *)
(* -----------------------------------------------------------------*)
IF (Xus_TN_MENU_POPUP.bo_Activ = TRUE) AND (Xus_TN_MENU_POPUP.bo_Update = TRUE) THEN

  Xus_TN_MENU_POPUP.bo_Update := FALSE; 

  (* -----------------------------------------------------------------*)
  (* überprüfung + nächstes anwählbares Sub-Menu suchen               *)
  (* -----------------------------------------------------------------*)
  in_index := Xus_TN_MENU_POPUP.in_Cur_Item;

  IF (in_index < INT#01) OR (in_index > Xus_TN_MENU_POPUP.in_Menu_E_Count) THEN
    in_Scroll_Offset := INT#01;
    in_index := Xus_TN_MENU_POPUP.in_Menu_E_Count;
  END_IF;

  (* -----------------------------------------------------------------*)
  (* aktueller Index steht auf Trennzeichen -> ändern                 *)
  (* -----------------------------------------------------------------*)
  ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_index-1);
  Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

  IF EQ_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN
    in_Scroll_Offset := INT#01;
  END_IF;

  (* -----------------------------------------------------------------*)
  (* Scroll-Offset                                                    *)
  (* -----------------------------------------------------------------*)
  IF in_Scroll_Offset <> INT#00 THEN

    FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Menu_E_Count DO;

      in_index:=INC2(in_index,in_Scroll_Offset,1,Xus_TN_MENU_POPUP.in_Menu_E_Count);

      ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_index-1);
      Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

      IF NE_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN
        EXIT;
      END_IF;

    END_FOR;
  END_IF;

  Xus_TN_MENU_POPUP.in_Cur_Item := in_index;
  in_Scroll_Offset := INT#00;

  (* -----------------------------------------------------------------*)
  (* Parameter laden                                                  *)
  (* -----------------------------------------------------------------*)
  in_COL  := Xus_TN_MENU_POPUP.in_X;
  in_ROW  := Xus_TN_MENU_POPUP.in_Y;
  in_ROWS := Xus_TN_MENU_POPUP.in_Rows;
  in_COLS := Xus_TN_MENU_POPUP.in_Cols;

  (* -----------------------------------------------------------------*)
  (* SUB-MENU-Titel ausgeben                                          *)
  (* -----------------------------------------------------------------*)
  in_COLS := in_COLS + INT#02;    (* Text um 2 Zeichen verlängern *)

  FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Menu_E_Count DO;

    in_ROW := in_ROW + INT#01;

    (* -----------------------------------------------------------------*)
    (* Zeichenfarbe bestimmen                                           *)
    (* -----------------------------------------------------------------*)
    IF in_Count = Xus_TN_MENU_POPUP.in_Cur_Item THEN
      by_ATTR := Xus_TN_MENU_POPUP.by_Attr_mF;
    ELSE
      by_ATTR := Xus_TN_MENU_POPUP.by_Attr_oF;
    END_IF;

    ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_Count-1);
    Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

    IF NE_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN

      FB_TN_SC_WRITE_C.Iin_Y         := in_ROW;
      FB_TN_SC_WRITE_C.Iin_X         := in_COL + INT#01;
      FB_TN_SC_WRITE_C.Iby_ATTR      := by_ATTR;
      FB_TN_SC_WRITE_C.Iin_LENGTH    := in_COLS;
      FB_TN_SC_WRITE_C.Iin_OPTION    := INT#02;   (* Center *)
      FB_TN_SC_WRITE_C.Ist_STRING    := ELEMENT_GET.ELEMENT_GET;
      FB_TN_SC_WRITE_C.Xus_TN_SCREEN := Xus_TN_SCREEN;
      FB_TN_SC_WRITE_C();
      Xus_TN_SCREEN := FB_TN_SC_WRITE_C.Xus_TN_SCREEN;

    END_IF;
  END_FOR;
END_IF;

(* -----------------------------------------------------------------*)
(* POPUP-Menu entfernen (Destroy)                                   *)
(* -----------------------------------------------------------------*)
IF (Xus_TN_MENU_POPUP.bo_Activ = TRUE) AND (Xus_TN_MENU_POPUP.bo_Destroy = TRUE) THEN

  Xus_TN_MENU_POPUP.bo_Destroy := FALSE;
  Xus_TN_MENU_POPUP.bo_Activ   := FALSE;

  (* -----------------------------------------------------------------*)
  (* alten Hintergrund aus Speicher wiederherstellen                  *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_AREA_RESTORE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_AREA_RESTORE();
  Xus_TN_SCREEN := FB_TN_SC_AREA_RESTORE.Xus_TN_SCREEN;
 
  Xus_TN_SCREEN.bo_Modal_Dialog := FALSE;
END_IF;

(* revision history

ks	06. apr. 2011	rev 1.1
	list_len und list_get durch element_count und element_get ersetzt

ks	10. mai. 2010	rev 1.0
	original version
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
