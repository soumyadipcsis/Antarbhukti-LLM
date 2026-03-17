(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DEMO
*)
(*@KEY@:DESCRIPTION*)

(* ------------------------------------------------------*)
(* Message-Level High-Byte = color / Low-Byte = Level    *)
(* ------------------------------------------------------*)

Color      Fordergrund       Hintergrund
00    =    (3) gelb          (4) dunkelblau      
01    =    (2) gruen         (4) dunkelblau      
02    =    (5) hell blaurot  (4) dunkelblau      
03    =    (6) hell zyan     (4) dunkelblau      
04    =    (1) rot           (4) dunkelblau      
05    =    (7) weiss         (4) dunkelblau      
06    =    (0) dunkelgrau    (4) dunkelblau      
07    =    (9) rot blinken   (4) dunkelblau      


Farbcodes Fordergrund

00 = dunkelgrau
01 = rot 
02 = gr¸n
03 = gelb
04 = blau
05 = hell blaurot
06 = hell zyan
07 = weiss
08 = dunkelgrau   blinkend
09 = rot          blinkend
10 = gr¸n         blinkend
11 = gelb         blinkend
12 = blau         blinkend
13 = hell blaurot blinkend
14 = hell zyan    blinkend
15 = weiss        blinkend

Farbcodes Hintergrund

00 = Schwarz
01 = dunkelrot
02 = dunkelgruen
03 = braun
04 = dunkelblau
05 = blaurot
06 = zyan
07 = hellgrau
(*@KEY@:END_DESCRIPTION*)
PROGRAM TN_VISION_DEMO_1

(*Group:extern*)


VAR_EXTERNAL
	LOG_CL_80 :	us_LOG_CONTROL_80;
END_VAR


(*Group:instance*)


VAR
	FB_TN_FRAMEWORK :	TN_FRAMEWORK;
	FB_LOWERCASE :	LOWERCASE;
	FB_LOG_MESSAGE :	LOG_MSG_80;
	FB_LOG_VIEWPORT :	LOG_VIEWPORT;
	FB_TN_SC_LINE :	TN_SC_LINE;
	FB_TN_SC_FILL :	TN_SC_FILL;
	FB_TN_SC_WRITE_C :	TN_SC_WRITE_C;
	FB_TN_SC_BOX :	TN_SC_BOX;
	FB_TN_SC_ADD_SHADOW :	TN_SC_ADD_SHADOW;
	FB_TN_SC_WRITE :	TN_SC_WRITE;
	FB_TN_SC_VIEWPORT :	TN_SC_VIEWPORT;
END_VAR


(*Group:default*)


VAR
	Xus_TN_MENU :	us_TN_MENU;
	Xus_TN_INPUT_CONTROL :	us_TN_INPUT_CONTROL;
	Xus_TN_SCREEN :	us_TN_SCREEN;
	us_LOG_VIEWPORT :	us_LOG_VIEWPORT;
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	IP_C :	oscat_IP_C;
	Gst_SysLog_Command :	STRING;
	in_index :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TN_FRAMEWORK
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Telnet-Framework                                                 *)
(* -----------------------------------------------------------------*)

FB_TN_FRAMEWORK.us_TN_INPUT_CONTROL := Xus_TN_INPUT_CONTROL;
FB_TN_FRAMEWORK.us_TN_SCREEN 		:= Xus_TN_SCREEN;
FB_TN_FRAMEWORK.us_TN_MENU			:= Xus_TN_MENU;
FB_TN_FRAMEWORK.S_BUF				:= S_BUF;
FB_TN_FRAMEWORK.R_BUF				:= R_BUF;
FB_TN_FRAMEWORK.IP_C				:= IP_C;
FB_TN_FRAMEWORK();
Xus_TN_INPUT_CONTROL	:= FB_TN_FRAMEWORK.us_TN_INPUT_CONTROL;
Xus_TN_SCREEN			:= FB_TN_FRAMEWORK.us_TN_SCREEN;
Xus_TN_MENU 			:= FB_TN_FRAMEWORK.us_TN_MENU;
S_BUF					:= FB_TN_FRAMEWORK.S_BUF;
R_BUF					:= FB_TN_FRAMEWORK.R_BUF;
IP_C					:= FB_TN_FRAMEWORK.IP_C;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: MENU_ACTION
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Modaler Dialog aktiv ?                                           *)
(* -----------------------------------------------------------------*)
IF (Xus_TN_SCREEN.bo_Modal_Dialog = TRUE) THEN RETURN; END_IF; 

IF Xus_TN_MENU.in_Menu_Selected > 0 THEN

  CASE Xus_TN_MENU.in_Menu_Selected OF

  41: (* Seite LOGIN aufrufen *)
    Xus_TN_SCREEN.in_Page_Number := INT#00;
    (* Ged‰chtnis lˆschen *)
    Xus_TN_MENU.bo_Destroy := TRUE; 

  END_CASE;

  (* Echo Menu-Auswahl *)
  Gst_SysLog_Command := CONCAT('MENU_SELECT: ',INT_TO_STRING(Xus_TN_MENU.in_Menu_Selected,'%d'));

  (* Menu-Auswahl lˆschen *)
  Xus_TN_MENU.in_Menu_Selected := 0;

END_IF;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M00_LOGIN_INIT
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Initialisierung der Daten und Strukturen                         *)
(* -----------------------------------------------------------------*)

IF (Xus_TN_SCREEN.in_Page_Number = INT#00 ) THEN
  Xus_TN_SCREEN.in_Page_Number := INT#01;

  (* -----------------------------------------------------------------*)
  (* Clear-Screen (Farbe setzen + Display lˆschen)                    *)
  (* -----------------------------------------------------------------*)
  Xus_TN_SCREEN.by_Clear_Screen_Attr := BYTE#16#00;
  Xus_TN_SCREEN.bo_Clear_Screen := TRUE;

  (* -----------------------------------------------------------------*)
  (* Screen initialisieren (mit Leerzeichen f¸llen)                   *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#00;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#23;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#179;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#76;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Titlezeile zeichnen                                              *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#00;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#00;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#32;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#07;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Title zeichnen                                                   *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#00;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#77; 
  FB_TN_SC_WRITE.Ist_STRING    := ' TELNET-VISION BIOS v1.0';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Fusszeile zeichnen                                              *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#23;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#23;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#32;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#37;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Rahmen f¸r Viewport zeichnen                                     *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_BOX.Iin_X1        := INT#03;
  FB_TN_SC_BOX.Iin_Y1        := INT#03;
  FB_TN_SC_BOX.Iin_X2        := INT#75;          
  FB_TN_SC_BOX.Iin_Y2        := INT#19;          
  FB_TN_SC_BOX.Iby_FILL      := BYTE#16#20;      (* F¸llung            *)
  FB_TN_SC_BOX.Iin_BORDER    := INT#02;          (* Double-Line Border *)
  FB_TN_SC_BOX.Iby_ATTR      := BYTE#16#74;      (* Weiss , Blau       *)
  FB_TN_SC_BOX.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_BOX();
  Xus_TN_SCREEN := FB_TN_SC_BOX.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Shadow f¸r Rahmen von Viewport zeichnen                          *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_ADD_SHADOW.Iin_X1        := INT#04;
  FB_TN_SC_ADD_SHADOW.Iin_Y1        := INT#04;
  FB_TN_SC_ADD_SHADOW.Iin_X2        := INT#76;
  FB_TN_SC_ADD_SHADOW.Iin_Y2        := INT#20;
  FB_TN_SC_ADD_SHADOW.Iin_OPTION    := INT#00;
  FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_ADD_SHADOW();
  Xus_TN_SCREEN := FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Title Viewport zeichnen                                          *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#31;
  FB_TN_SC_WRITE.Iin_Y         := INT#03;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#74; 
  FB_TN_SC_WRITE.Ist_STRING    := '[ LOGIN-DIALOG ]';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* LOGO Zeilen zeichnen                                             *)
  (* -----------------------------------------------------------------*)
  FOR in_index := 5 TO 16 DO

	CASE in_index OF

		05: FB_TN_SC_WRITE.Ist_STRING := '€€€€€€€€ª €€€€€€€ª €€ª      €€€ª   €€ª €€€€€€€ª €€€€€€€€ª';
		06: FB_TN_SC_WRITE.Ist_STRING := '»ÕÕ€€…ÕÕº €€…ÕÕÕÕº €€∫      €€€€ª  €€∫ €€…ÕÕÕÕº »ÕÕ€€…ÕÕº';
		07: FB_TN_SC_WRITE.Ist_STRING := '   €€∫    €€€€€ª   €€∫      €€…€€ª €€∫ €€€€€ª      €€∫';
		08: FB_TN_SC_WRITE.Ist_STRING := '   €€∫    €€…ÕÕº   €€∫      €€∫»€€ª€€∫ €€…ÕÕº      €€∫';
		09: FB_TN_SC_WRITE.Ist_STRING := '   €€∫    €€€€€€€ª €€€€€€€ª €€∫ »€€€€∫ €€€€€€€ª    €€∫';
		10: FB_TN_SC_WRITE.Ist_STRING := '   »Õº    »ÕÕÕÕÕÕº »ÕÕÕÕÕÕº »Õº  »ÕÕÕº »ÕÕÕÕÕÕº    »Õº';
		11: FB_TN_SC_WRITE.Ist_STRING := '     €€ª   €€ª €€ª €€€€€€€ª €€ª  €€€€€€ª  €€€ª   €€ª';
		12: FB_TN_SC_WRITE.Ist_STRING := '     €€∫   €€∫ €€∫ €€…ÕÕÕÕº €€∫ €€…ÕÕÕ€€ª €€€€ª  €€∫';
		13: FB_TN_SC_WRITE.Ist_STRING := '     €€∫   €€∫ €€∫ €€€€€€€ª €€∫ €€∫   €€∫ €€…€€ª €€∫';
		14: FB_TN_SC_WRITE.Ist_STRING := '     »€€ª €€…º €€∫ »ÕÕÕÕ€€∫ €€∫ €€∫   €€∫ €€∫»€€ª€€∫';
		15: FB_TN_SC_WRITE.Ist_STRING := '      »€€€€…º  €€∫ €€€€€€€∫ €€∫ »€€€€€€…º €€∫ »€€€€∫';
		16: FB_TN_SC_WRITE.Ist_STRING := '       »ÕÕÕº   »Õº »ÕÕÕÕÕÕº »Õº  »ÕÕÕÕÕº  »Õº  »ÕÕÕº';

    END_CASE;

    FB_TN_SC_WRITE.Iin_Y         := in_index;
    FB_TN_SC_WRITE.Iin_X         := INT#11;
    FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#34; 
    FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
    FB_TN_SC_WRITE();
    Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  END_FOR;

  (* -----------------------------------------------------------------*)
  (* Trennlinie zeichnen                                              *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_LINE.Iin_X1			:= INT#03;
  FB_TN_SC_LINE.Iin_Y1			:= INT#17;
  FB_TN_SC_LINE.Iin_X2			:= INT#75;
  FB_TN_SC_LINE.Iin_Y2			:= INT#17;
  FB_TN_SC_LINE.Iby_ATTR		:= BYTE#16#74;
  FB_TN_SC_LINE.Iby_BORDER		:= BYTE#02;
  FB_TN_SC_LINE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
  FB_TN_SC_LINE();
  Xus_TN_SCREEN := FB_TN_SC_LINE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Alle Input-Controls initialisieren                               *)
  (* -----------------------------------------------------------------*)

  Xus_TN_INPUT_CONTROL.bo_Enable      := FALSE;
  
  (* -----------------------------------------------------------------*)
  (* Initialisierung der Eingabe-Zeile                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Type                  := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Y                     := INT#18;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_X                     := INT#49;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_mF               := BYTE#16#17;  
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_oF               := BYTE#16#47;  
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Cursor_Pos            := INT#0;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Only_Num        := FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Hidden          := TRUE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask            := '                ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Data            := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_ToolTip         := ' enter password | press enter to login     |';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Input_Option          := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_X_Offset        := INT#-12;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Title_Attr            := BYTE#16#34;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Title_String 		 := 'password:  [                ]';

  (* -----------------------------------------------------------------*)
  (* Initialisierung Selection Text                                   *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Type                  := INT#03;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Y                     := INT#18;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_X                     := INT#18;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Attr_mF               := BYTE#16#17;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Attr_oF               := BYTE#16#47;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_ToolTip         := ' select user       | press enter to select |';;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Input_Option          := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Title_Y_Offset     	 := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Title_X_Offset     	 := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Title_Attr         	 := BYTE#16#34;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Title_String 		 := ' user ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_Mask            := '           ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_Data            := 'admin#guest#maintenance';

  (* -----------------------------------------------------------------*)
  (* Control-Tool-Tip                                                 *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_ToolTip_Y := INT#23;
  Xus_TN_INPUT_CONTROL.in_ToolTip_X := INT#00;
  Xus_TN_INPUT_CONTROL.by_ToolTip_Attr := BYTE#16#37;
  Xus_TN_INPUT_CONTROL.in_ToolTip_Size := INT#80;

  (* -----------------------------------------------------------------*)
  (* Control-Verwaltung initialisieren                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_Count       := INT#02;
  Xus_TN_INPUT_CONTROL.bo_Enable      := TRUE;
  Xus_TN_INPUT_CONTROL.bo_Reset_Fokus := TRUE;

END_IF;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M01_LOGIN_AKTION
IEC_LANGUAGE: ST
*)
IF (Xus_TN_SCREEN.in_Page_Number = INT#01) THEN
  (* eingegebenen String ¸bernehmen *)
  IF Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Entered = TRUE THEN

    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Entered := FALSE;
    FB_LOWERCASE(str:=Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String);
    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String:=FB_LOWERCASE.lowercase;

    IF EQ_STRING(Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String,'oscat') THEN
      Xus_TN_SCREEN.in_Page_Number := INT#10;

      Gst_SysLog_Command := CONCAT('LOGON: USER-',Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_String);

    ELSE
      FB_TN_SC_WRITE_C.Iin_X			:= Xus_TN_INPUT_CONTROL.in_ToolTip_X;
      FB_TN_SC_WRITE_C.Iin_Y			:= Xus_TN_INPUT_CONTROL.in_ToolTip_Y;
      FB_TN_SC_WRITE_C.Iby_ATTR			:= BYTE#16#F1;
      FB_TN_SC_WRITE_C.Iin_OPTION		:= INT#02;    (* Center-String *)
      FB_TN_SC_WRITE_C.Iin_LENGTH		:= Xus_TN_INPUT_CONTROL.in_ToolTip_Size;
      FB_TN_SC_WRITE_C.Ist_STRING		:= ' Password Failed   ';
      FB_TN_SC_WRITE_C.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
      FB_TN_SC_WRITE_C();
      Xus_TN_SCREEN := FB_TN_SC_WRITE_C.Xus_TN_SCREEN;

      Gst_SysLog_Command := CONCAT('LOGON: ',FB_TN_SC_WRITE_C.Ist_STRING);

    END_IF;
  END_IF;
END_IF;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M10_DEBUG_INIT
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Initialisierung der Daten und Strukturen                         *)
(* -----------------------------------------------------------------*)

IF (Xus_TN_SCREEN.in_Page_Number = INT#10 ) THEN
  Xus_TN_SCREEN.in_Page_Number := INT#11;

  (* -----------------------------------------------------------------*)
  (* Clear-Screen (Farbe setzen + Display lˆschen)                    *)
  (* -----------------------------------------------------------------*)
  Xus_TN_SCREEN.by_Clear_Screen_Attr := BYTE#16#00;
  Xus_TN_SCREEN.bo_Clear_Screen := TRUE;

  (* -----------------------------------------------------------------*)
  (* Screen initialisieren (mit Leerzeichen f¸llen)                   *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#00;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#23;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#179;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#76;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Titlezeile zeichnen                                              *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#00;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#00;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#32;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#07;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Fusszeile zeichnen                                              *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#23;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#23;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#32;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#37;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Rahmen f¸r Viewport zeichnen                                     *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_BOX.Iin_X1        := INT#00;
  FB_TN_SC_BOX.Iin_Y1        := INT#01;
  FB_TN_SC_BOX.Iin_X2        := INT#77;          
  FB_TN_SC_BOX.Iin_Y2        := INT#17;          
  FB_TN_SC_BOX.Iby_FILL      := BYTE#16#00;      (* keine F¸llung      *)
  FB_TN_SC_BOX.Iin_BORDER    := INT#02;          (* Double-Line Border *)
  FB_TN_SC_BOX.Iby_ATTR      := BYTE#16#74;      (* Weiss , Blau       *)
  FB_TN_SC_BOX.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_BOX();
  Xus_TN_SCREEN := FB_TN_SC_BOX.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Shadow f¸r Rahmen von Viewport zeichnen                          *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_ADD_SHADOW.Iin_X1        := INT#01;
  FB_TN_SC_ADD_SHADOW.Iin_Y1        := INT#02;
  FB_TN_SC_ADD_SHADOW.Iin_X2        := INT#78;
  FB_TN_SC_ADD_SHADOW.Iin_Y2        := INT#18;
  FB_TN_SC_ADD_SHADOW.Iin_OPTION    := INT#00;
  FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_ADD_SHADOW();
  Xus_TN_SCREEN := FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Trennlinie Viewport_Data und Commandline zeichnen                *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_LINE.Iin_X1			:= INT#00;
  FB_TN_SC_LINE.Iin_Y1			:= INT#15;
  FB_TN_SC_LINE.Iin_X2			:= INT#77;
  FB_TN_SC_LINE.Iin_Y2			:= INT#15;
  FB_TN_SC_LINE.Iby_ATTR		:= BYTE#16#74;
  FB_TN_SC_LINE.Iby_BORDER		:= BYTE#02;
  FB_TN_SC_LINE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
  FB_TN_SC_LINE();
  Xus_TN_SCREEN := FB_TN_SC_LINE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Title Viewport zeichnen                                          *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#29;
  FB_TN_SC_WRITE.Iin_Y         := INT#01;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#74; 
  FB_TN_SC_WRITE.Ist_STRING    := '[ SYSTEM-CONSOLE ]';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Rahmen f¸r Parameter-Feld zeichnen                               *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_BOX.Iin_X1        := INT#02;
  FB_TN_SC_BOX.Iin_Y1        := INT#19;
  FB_TN_SC_BOX.Iin_X2        := INT#74;          
  FB_TN_SC_BOX.Iin_Y2        := INT#21;
  FB_TN_SC_BOX.Iby_FILL      := BYTE#16#20;      
  FB_TN_SC_BOX.Iin_BORDER    := INT#01;          (* Double-Line Border *)
  FB_TN_SC_BOX.Iby_ATTR      := BYTE#16#74;      (* Weiss , Blau       *)
  FB_TN_SC_BOX.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_BOX();
  Xus_TN_SCREEN := FB_TN_SC_BOX.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Shadow f¸r Rahmen von Parameter-Feld zeichnen                    *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_ADD_SHADOW.Iin_X1        := INT#03;
  FB_TN_SC_ADD_SHADOW.Iin_Y1        := INT#20;
  FB_TN_SC_ADD_SHADOW.Iin_X2        := INT#75;
  FB_TN_SC_ADD_SHADOW.Iin_Y2        := INT#22;
  FB_TN_SC_ADD_SHADOW.Iin_OPTION    := INT#00;
  FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_ADD_SHADOW();
  Xus_TN_SCREEN := FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Alle Input-Controls initialisieren                               *)
  (* -----------------------------------------------------------------*)

  Xus_TN_INPUT_CONTROL.bo_Enable      := FALSE;

  (* -----------------------------------------------------------------*)
  (* Initialisierung der Eingabe-Zeile                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Type                  := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Y                     := INT#16;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_X                     := INT#09;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_mF               := BYTE#16#72;    (* Weiss, Gr¸n *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_oF               := BYTE#16#74;    (* Weiss, Blau *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Cursor_Pos            := INT#0;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Only_Num        := FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Hidden          := FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask            := '                                                                    ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Data            := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_ToolTip         := 'Eingabezeile aktiv       | SCROLL F1/F2/F3/F4 |';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_X_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Title_Attr            := BYTE#16#34;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Title_String 		 := 'Befehl: ';
  
  (* -----------------------------------------------------------------*)
  (* Initialisierung Selection Text                                   *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Type                  := INT#03;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Y                     := INT#20;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_X                     := INT#18;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Attr_mF               := BYTE#16#17;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Attr_oF               := BYTE#16#47;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_ToolTip         := ' aktuellen LOG-Level aendern     | press enter to select |';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Input_Option          := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Title_Y_Offset  		 := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Title_X_Offset  		 := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Title_Attr      		 := BYTE#16#34;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Title_String 		 := ' LOG-Level ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_Mask            := '  ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_Data            := '01#02#03#04#05#06#07#08#09#10#11#12#13#14#15';

  (* -----------------------------------------------------------------*)
  (* Initialisierung Selection Text                                   *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Y                     := INT#20;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_X                     := INT#37;			
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].by_Attr_mF               := BYTE#16#17;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].by_Attr_oF               := BYTE#16#47;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Input_ToolTip         := ' Optionline aktiv      | press space to select |';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Title_X_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].by_Title_Attr            := BYTE#16#34;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Title_String 		 := '  Selektion  ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Input_Mask            := '     ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Input_Data            := '[ ]#[x]';

  (* -----------------------------------------------------------------*)
  (* Initialisierung Selection Text                                   *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Y                     := INT#20;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_X                     := INT#58;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].by_Attr_mF               := BYTE#16#17;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].by_Attr_oF               := BYTE#16#47;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Input_ToolTip         := ' Selektion-Text aktiv      | press space to select |';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Title_X_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].by_Title_Attr            := BYTE#16#34;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Title_String 		 := ' Betriebsart ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Input_Mask            := '               ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Input_Data            := '<Auto>#<Hand>#<Einzelschritt>#<Stop>#<Restart>';

  (* -----------------------------------------------------------------*)
  (* Control-Tool-Tip                                                 *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_ToolTip_Y := INT#23;
  Xus_TN_INPUT_CONTROL.in_ToolTip_X := INT#00;
  Xus_TN_INPUT_CONTROL.by_ToolTip_Attr := BYTE#16#37;
  Xus_TN_INPUT_CONTROL.in_ToolTip_Size := INT#60;

  (* -----------------------------------------------------------------*)
  (* Control-Verwaltung initialisieren                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_Count       := INT#04;
  Xus_TN_INPUT_CONTROL.bo_Enable      := TRUE;
  Xus_TN_INPUT_CONTROL.bo_Reset_Fokus := TRUE;

  (* LOG-Viewport initialisieren und Neuzeichnen auslˆsen *)
  us_LOG_VIEWPORT.COUNT := 13;
  us_LOG_VIEWPORT.UPDATE := TRUE;

  (* -----------------------------------------------------------------*)
  (* Menu initialisieren                                              *)
  (* -----------------------------------------------------------------*)
  Xus_TN_MENU.in_X := INT#00;
  Xus_TN_MENU.in_Y := INT#00;
  Xus_TN_MENU.by_Attr_mF := BYTE#16#33;       (* yellow + brown *)
  Xus_TN_MENU.by_Attr_oF := BYTE#16#0F;       (* schwarz + grau *)
  Xus_TN_MENU.st_MENU_TEXT := 'Datei#Bearbeiten#Ansicht#Ende';
  Xus_TN_MENU.st_MENU_TEXT := CONCAT(Xus_TN_MENU.st_MENU_TEXT,'%oeffnen#-#speichern#beenden%loeschen#-#einfuegen#-#kopieren');
  Xus_TN_MENU.st_MENU_TEXT := CONCAT(Xus_TN_MENU.st_MENU_TEXT,'%alles#detail#kopieren%Logout');

  Xus_TN_MENU.bo_Create        := TRUE;
  
END_IF;
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M11_DEBUG_AKTION
IEC_LANGUAGE: ST
*)

IF (Xus_TN_SCREEN.in_Page_Number = INT#11) THEN 

  (* Eingabezeile: Befehl -> eingegebenen String ¸bernehmen *)
  IF (Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Entered = TRUE) THEN

    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Entered := FALSE;
    Gst_SysLog_Command := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String;

  END_IF;

  (* Eingabezeile: LOG_LEVEL -> eingegebenen String ¸bernehmen *)
  IF (Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].bo_Input_Entered = TRUE) THEN

    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].bo_Input_Entered := FALSE;
    Gst_SysLog_Command := CONCAT('LOG_LEVEL ',Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_String);

  END_IF;

  (* -----------------------------------------------------------------*)
  (* LOG-Viewport - Scroll Funktionen                                 *)
  (* -----------------------------------------------------------------*)
  IF (Xus_TN_INPUT_CONTROL.in_Focus_at = INT#01) THEN
    CASE _BYTE_TO_INT(Xus_TN_SCREEN.by_Input_Exten_Code) OF
    80: (* F1 Taste *)
      us_LOG_VIEWPORT.MOVE_TO_X := 30001; (* Scrollen zum Listenanfang *)
    81: (* F2 Taste *)
      us_LOG_VIEWPORT.MOVE_TO_X := us_LOG_VIEWPORT.COUNT; (* Scrollen eine Seite nach oben *)
    82: (* F3 Taste *)
      us_LOG_VIEWPORT.MOVE_TO_X := 0 - us_LOG_VIEWPORT.COUNT;
    83: (* F4 Taste *)
      us_LOG_VIEWPORT.MOVE_TO_X := 30000; (* Scrollen zum Listenende *)
    END_CASE;
  END_IF;

  (* -----------------------------------------------------------------*)
  (* LOG-Viewport Updaten                                             *)
  (* -----------------------------------------------------------------*)
  FB_LOG_VIEWPORT.LC  := LOG_CL_80;
  FB_LOG_VIEWPORT.LV := us_LOG_VIEWPORT;
  FB_LOG_VIEWPORT();
  LOG_CL_80  := FB_LOG_VIEWPORT.LC;
  us_LOG_VIEWPORT := FB_LOG_VIEWPORT.LV;

  (* -----------------------------------------------------------------*)
  (* LOG-Viewport zeichnen                                            *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_VIEWPORT.Xus_LOG_VIEWPORT	:= us_LOG_VIEWPORT;
  FB_TN_SC_VIEWPORT.Xus_LOG_CONTROL		:= LOG_CL_80;
  FB_TN_SC_VIEWPORT.Xus_TN_SCREEN		:= Xus_TN_SCREEN;
  FB_TN_SC_VIEWPORT.Iin_X				:= INT#01;
  FB_TN_SC_VIEWPORT.Iin_Y				:= INT#02;
  FB_TN_SC_VIEWPORT.Iin_Width			:= INT#76;
  FB_TN_SC_VIEWPORT.Idw_ATTR_1			:= DWORD#16#64542434;   (* Color + Level 3:2:1:0 *)
  FB_TN_SC_VIEWPORT.Idw_ATTR_2			:= DWORD#16#94047414;   (* Color + Level 7:6:5:4 *)
  FB_TN_SC_VIEWPORT.Iti_TIME			:= TIME#100ms;
  FB_TN_SC_VIEWPORT();
  us_LOG_VIEWPORT := FB_TN_SC_VIEWPORT.Xus_LOG_VIEWPORT;
  LOG_CL_80  := FB_TN_SC_VIEWPORT.Xus_LOG_CONTROL;
  Xus_TN_SCREEN   := FB_TN_SC_VIEWPORT.Xus_TN_SCREEN;

END_IF;
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: Command
IEC_LANGUAGE: ST
*)
(* Kommando auswerten *)
IF LEN(Gst_SysLog_Command) > 0 THEN 

  (* Kommando echo *)
  LOG_CL_80.NEW_MSG := CONCAT('ACTION: ',Gst_SysLog_Command);
  LOG_CL_80.NEW_MSG_OPTION := DWORD#0;
  FB_LOG_MESSAGE();

  Gst_SysLog_Command :='';

END_IF;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
