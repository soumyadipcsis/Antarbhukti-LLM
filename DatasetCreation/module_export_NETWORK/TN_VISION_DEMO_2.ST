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
02 = grün
03 = gelb
04 = blau
05 = hell blaurot
06 = hell zyan
07 = weiss
08 = dunkelgrau   blinkend
09 = rot          blinkend
10 = grün         blinkend
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
PROGRAM TN_VISION_DEMO_2

(*Group:default*)


VAR
	FB_TN_FRAMEWORK :	TN_FRAMEWORK;
	FB_LOWERCASE :	LOWERCASE;
	FB_TN_SC_FILL :	TN_SC_FILL;
	FB_TN_SC_WRITE_C :	TN_SC_WRITE_C;
	FB_TN_SC_WRITE :	TN_SC_WRITE;
	Xus_TN_MENU :	us_TN_MENU;
	Xus_TN_INPUT_CONTROL :	us_TN_INPUT_CONTROL;
	Xus_TN_SCREEN :	us_TN_SCREEN;
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	IP_C :	oscat_IP_C;
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
NAME: M00_MSS_LOGIN_INIT
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Initialisierung der Daten und Strukturen                         *)
(* -----------------------------------------------------------------*)
IF (Xus_TN_SCREEN.in_Page_Number = INT#00) THEN
  Xus_TN_SCREEN.in_Page_Number := INT#01;

  (* -----------------------------------------------------------------*)
  (* Clear-Screen (Farbe setzen + Display löschen)                    *)
  (* -----------------------------------------------------------------*)
  Xus_TN_SCREEN.by_Clear_Screen_Attr := BYTE#16#00;
  Xus_TN_SCREEN.bo_Clear_Screen := TRUE;

  (* -----------------------------------------------------------------*)
  (* Screen initialisieren (mit Leerzeichen füllen)                   *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#00;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#23;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#32;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#00;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X			:= INT#00;
  FB_TN_SC_WRITE.Iin_Y			:= INT#00;
  FB_TN_SC_WRITE.Iby_ATTR		:= BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING		:= 'Login Screen                                                     FL SWITCH MM HS';
  FB_TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#03;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'XXXXXXXXX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#04;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   X  XX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#05;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   O   X      ---> Phoenix Contact Managed Switch System <---';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#06;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   X  XX               Phoenix Contact GmbH & Co KG';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#07;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   XXXXX                   www.PhoenixContact.com';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#08;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   XXXXX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;
 
  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#09;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'XXXXXXXXX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#11;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := '                Running switch application version:  4.00';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Alle Input-Controls initialisieren                               *)
  (* -----------------------------------------------------------------*)

  Xus_TN_INPUT_CONTROL.bo_Enable      := FALSE;

  (* -----------------------------------------------------------------*)
  (* Initialisierung der Eingabe-Zeile                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Type                  	:= INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Y                     	:= INT#17;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_X                     	:= INT#33;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_mF               	:= BYTE#16#70;    
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_oF               	:= BYTE#16#70;    
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Cursor_Pos            	:= INT#0;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Only_Num        	:= FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Hidden          	:= TRUE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask            	:= '                ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Data            	:= Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_ToolTip         	:= STRING#'';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Input_Option				:= INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_Y_Offset			:= INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_X_Offset     		:= INT#-12;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Title_Attr				:= BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Title_String				:= 'Password:  [                ]';

  (* -----------------------------------------------------------------*)
  (* Control-Tool-Tip                                                 *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_ToolTip_Y := INT#23;
  Xus_TN_INPUT_CONTROL.in_ToolTip_X	:= INT#09;
  Xus_TN_INPUT_CONTROL.by_ToolTip_Attr := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.in_ToolTip_Size := INT#30;

  (* -----------------------------------------------------------------*)
  (* Control-Verwaltung initialisieren                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_Count       := INT#01;
  Xus_TN_INPUT_CONTROL.bo_Enable      := TRUE;
  Xus_TN_INPUT_CONTROL.bo_Reset_Fokus := TRUE;

END_IF;
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M01_MSS_LOGIN_AKTION
IEC_LANGUAGE: ST
*)
IF (Xus_TN_SCREEN.in_Page_Number = INT#01) THEN

  (* eingegebenen String übernehmen *)
  IF Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Entered = TRUE THEN

    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Entered := FALSE;

    FB_LOWERCASE(str:=Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String);
    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String:=FB_LOWERCASE.lowercase;

    IF EQ_STRING(Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_String,'oscat') THEN
        Xus_TN_SCREEN.in_Page_Number := INT#04;
    ELSE
      FB_TN_SC_WRITE_C.Iin_Y			:= Xus_TN_INPUT_CONTROL.in_ToolTip_Y;
      FB_TN_SC_WRITE_C.Iin_X			:= Xus_TN_INPUT_CONTROL.in_ToolTip_X;
      FB_TN_SC_WRITE_C.Iby_ATTR			:= BYTE#16#F1;
      FB_TN_SC_WRITE_C.Iin_OPTION		:= INT#02;    (* Center-String *)
      FB_TN_SC_WRITE_C.Iin_LENGTH		:= Xus_TN_INPUT_CONTROL.in_ToolTip_Size;
      FB_TN_SC_WRITE_C.Ist_STRING		:= ' User Password Failed   ';
      FB_TN_SC_WRITE_C.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
      FB_TN_SC_WRITE_C();
      Xus_TN_SCREEN := FB_TN_SC_WRITE_C.Xus_TN_SCREEN;

    END_IF;
  END_IF;
END_IF;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M04_MSS_INIT
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* Initialisierung der Daten und Strukturen                         *)
(* -----------------------------------------------------------------*)
IF (Xus_TN_SCREEN.in_Page_Number = INT#04) THEN
  Xus_TN_SCREEN.in_Page_Number := INT#05;

  (* -----------------------------------------------------------------*)
  (* Clear-Screen (Farbe setzen + Display löschen)                    *)
  (* -----------------------------------------------------------------*)
  Xus_TN_SCREEN.by_Clear_Screen_Attr := BYTE#16#00;
  Xus_TN_SCREEN.bo_Clear_Screen := TRUE;

  (* -----------------------------------------------------------------*)
  (* Screen initialisieren (mit Leerzeichen füllen)                   *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_FILL.Iin_X1        := INT#00;
  FB_TN_SC_FILL.Iin_Y1        := INT#00;
  FB_TN_SC_FILL.Iin_X2        := INT#79;
  FB_TN_SC_FILL.Iin_Y2        := INT#23;
  FB_TN_SC_FILL.Iby_CHAR      := BYTE#32;
  FB_TN_SC_FILL.Iby_Attr      := BYTE#16#00;
  FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_FILL();
  Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#00;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'Basic Switch Configuration                                       FL SWITCH MM HS';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#03;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'XXXXXXXXX        MAC Address             : 00:A0:45:00:6E:9B';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#04;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   X  XX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#05;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   O   X';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#06;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   X  XX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#07;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   XXXXX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#08;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'X   XXXXX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;
 
  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#00;
  FB_TN_SC_WRITE.Iin_Y         := INT#09;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'XXXXXXXXX';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  (* -----------------------------------------------------------------*)
  (* Alle Input-Controls initialisieren                               *)
  (* -----------------------------------------------------------------*)

  Xus_TN_INPUT_CONTROL.bo_Enable      := FALSE;

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Type                  := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Y                     := INT#04;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_mF               := BYTE#16#07;    (* Weiss, Grün *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Attr_oF               := BYTE#16#70;    (* Weiss, Blau *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Cursor_Pos            := INT#0;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Only_Num        := TRUE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Input_Hidden          := FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask            := '   .   .   .   ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Data            := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_ToolTip         := 'Enter Agent IP Address in decimal dot format (e.g., 209.131.209.13)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Input_Option          := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_Y_Offset     	 := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Title_String 		 := 'IP Address              : [149.208.100.100]';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Type                  := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Y                     := INT#05;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Attr_mF               := BYTE#16#07;    (* Weiss, Grün *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Attr_oF               := BYTE#16#70;    (* Weiss, Blau *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Cursor_Pos            := INT#0;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].bo_Input_Only_Num        := TRUE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].bo_Input_Hidden          := FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_Mask            := '   .   .   .   ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_Data            := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Input_ToolTip         := 'Enter Agent Netmask (e.g., 255.255.255.0)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Input_Option          := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[2].st_Title_String 		 := 'Subnet Mask             : [255.255.255.128]';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Type                  := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Y                     := INT#06;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].by_Attr_mF               := BYTE#16#07;    (* Weiss, Grün *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].by_Attr_oF               := BYTE#16#70;    (* Weiss, Blau *)
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Cursor_Pos            := INT#0;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].bo_Input_Only_Num        := TRUE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].bo_Input_Hidden          := FALSE;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Input_Mask            := '   .   .   .   ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Input_Data            := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].st_Input_Mask;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Input_ToolTip         := 'Enter Agent Default Gateway, (e.g., 209.131.209.1)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Input_Option          := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[3].st_Title_String 	     := 'Default Gateway         : [149.208.100.1  ]';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Y                     := INT#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Input_Mask            := '       ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Input_Data            := 'BootP  #DHCP   #DCP    #Static ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Input_ToolTip         := 'Push SPACE to select the address assignment (effective after reboot)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[4].st_Title_String 		 := 'IP Parameter Assignment : <BootP  >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].in_Y                     := INT#09;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].st_Input_Mask            := '                              ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].st_Input_Data            := 'No Redundancy#Rapid Spanning Tree, Disabled#Rapid Spanning Tree, Enabled';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].st_Input_ToolTip         := 'Push SPACE to chose redundancy (network disruption for few seconds if enabled)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[5].st_Title_String 		 := 'Redundancy              : <No Redundancy                 >';

  (* -----------------------------------------------------------------*)
  (* Statische Texte ausgeben                                         *)
  (* -----------------------------------------------------------------*)
  FB_TN_SC_WRITE.Iin_X         := INT#17;
  FB_TN_SC_WRITE.Iin_Y         := INT#10;
  FB_TN_SC_WRITE.Iby_ATTR      := BYTE#16#70; 
  FB_TN_SC_WRITE.Ist_STRING    := 'Current Vlan Status     :  VLAN Transparent';
  FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
  FB_TN_SC_WRITE();
  Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].in_Y                     := INT#11;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].st_Input_Mask            := '                        ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].st_Input_Data            := 'VLAN Transparent#VLAN Tagging';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].st_Input_ToolTip         := 'Push SPACE to toggle the VLAN Mode (effective after reboot)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[6].st_Title_String 		 := 'Vlan Mode               : <VLAN Transparent        >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].in_Y                     := INT#12;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].st_Input_Mask            := '       ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].st_Input_Data            := 'Disable#Enable';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].st_Input_ToolTip         := 'Push SPACE to Enable/Disable Port Security';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[7].st_Title_String 		 := 'Port Security           : <Disable>';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].in_Y                     := INT#13;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].st_Input_Mask            := '       ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].st_Input_Data            := 'Disable#Enable';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].st_Input_ToolTip         := 'Push SPACE to Enable/Disable Access Control for the WEB Interface';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[8].st_Title_String 		 := 'Access Control for Web  : <Disable>';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].in_Y                     := INT#14;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].st_Input_Mask            := '        ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].st_Input_Data            := 'Default#Profinet';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].st_Input_ToolTip         := 'Push SPACE to select the switch operating mode';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[9].st_Title_String 		 := 'Switch Operating Mode   : <Default >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].in_Y                     := INT#16;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].st_Input_Mask            := '       ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].st_Input_Data            := 'Enable#Disable';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].st_Input_ToolTip         := 'Push SPACE to Enable/Disable Web Interface (effective after reboot)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[10].st_Title_String 		  := 'Web Interface           : <Enable >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].in_Y                     := INT#17;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].st_Input_Mask            := '       ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].st_Input_Data            := 'Enable#Disable';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].st_Input_ToolTip         := 'Push SPACE to Enable/Disable Telnet Interface (effective after reboot)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[11].st_Title_String 		  := 'Telnet Interface        : <Enable >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].in_Y                     := INT#18;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].st_Input_Mask            := '       ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].st_Input_Data            := 'Enable#Disable';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].st_Input_ToolTip         := 'Push SPACE to Enable/Disable SNMP Interface (effective after reboot)';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[12].st_Title_String 		  := 'SNMP Interface          : <Enable >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].in_Y                     := INT#20;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].in_X                     := INT#44;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].st_Input_Mask            := '                                 ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].st_Input_Data            := 'No reset#Reset Switch#Reset Switch to factory defaults';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].st_Input_ToolTip         := 'Push SPACE to select Reset Option';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].in_Input_Option          := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].in_Title_X_Offset        := INT#-27;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[13].st_Title_String 		  := 'Reset                   : <No reset                         >';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].in_Y                     := INT#22;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].in_X                     := INT#18;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].st_Input_ToolTip         := 'Apply and save ALL changes to permanent memory';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].in_Input_Option          := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].in_Title_X_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].st_Title_String 		  := '';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].st_Input_Mask            := '    ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[14].st_Input_Data            := 'SAVE';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].in_Y                     := INT#22;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].in_X                     := INT#11;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].st_Input_ToolTip         := 'Apply changes';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].in_Input_Option          := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].in_Title_X_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].st_Title_String 		  := '';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].st_Input_Mask            := '     ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[15].st_Input_Data            := 'APPLY';

  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].in_Type                  := INT#02;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].in_Y                     := INT#22;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].in_X                     := INT#03;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].by_Attr_mF               := BYTE#16#07;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].by_Attr_oF               := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].st_Input_ToolTip         := 'Return to Main Menu';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].in_Input_Option          := INT#01;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].in_Title_Y_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].in_Title_X_Offset        := INT#00;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].by_Title_Attr            := BYTE#16#70;
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].st_Title_String 		  := '';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].st_Input_Mask            := '      ';
  Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].st_Input_Data            := 'LOGOUT';

  (* -----------------------------------------------------------------*)
  (* Control-Tool-Tip                                                 *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_ToolTip_Y := INT#23;
  Xus_TN_INPUT_CONTROL.in_ToolTip_X	:= INT#00;
  Xus_TN_INPUT_CONTROL.by_ToolTip_Attr := BYTE#07;
  Xus_TN_INPUT_CONTROL.in_ToolTip_Size := INT#80;

  (* -----------------------------------------------------------------*)
  (* Control-Verwaltung initialisieren                                *)
  (* -----------------------------------------------------------------*)
  Xus_TN_INPUT_CONTROL.in_Count       := INT#16;
  Xus_TN_INPUT_CONTROL.bo_Enable      := TRUE;
  Xus_TN_INPUT_CONTROL.bo_Reset_Fokus := TRUE;

END_IF;
(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: M05_MSS_AKTION
IEC_LANGUAGE: ST
*)
IF (Xus_TN_SCREEN.in_Page_Number = INT#05) THEN
  (* eingegebenen String übernehmen *)
  IF Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].bo_Input_Entered = TRUE THEN
    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[16].bo_Input_Entered := FALSE;
    Xus_TN_SCREEN.in_Page_Number := INT#0;
  END_IF;
END_IF;
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
