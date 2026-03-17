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

TN_SC_VIEWPORT verwaltet und zeichnet einen rechteckigen Bereich in dem der Log-buffer angezeigt wird

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_VIEWPORT

(*Group:instances*)


VAR
	FB_TN_SC_WRITE :	TN_SC_WRITE;
	FB_FIX :	FIX;
	FB_TON :	TON;
END_VAR


(*Group:lokal*)


VAR
	in_index :	INT;
	in_Color :	INT;
	by_Attr :	BYTE;
	in_count :	INT;
END_VAR


(*Group:IN_OUT*)


VAR_IN_OUT
	Xus_LOG_VIEWPORT :	us_LOG_VIEWPORT;
	Xus_LOG_CONTROL :	us_LOG_CONTROL_80;
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


VAR_INPUT
	Iin_X :	INT;
	Iin_Y :	INT;
	Iin_Width :	INT;
	Idw_ATTR_1 :	DWORD;
	Idw_ATTR_2 :	DWORD;
	Iti_TIME :	TIME;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
(* -----------------------------------------------------------------*)
(* LOG-Messages ausgeben                                            *)
(* -----------------------------------------------------------------*)

(* -----------------------------------------------------------------*)
(* Update gewünscht und Verzögerungszeit abgelaufen                 *)
(* -----------------------------------------------------------------*)
IF Xus_LOG_VIEWPORT.UPDATE AND FB_TON.Q THEN

  Xus_LOG_VIEWPORT.UPDATE := FALSE;

  (* -----------------------------------------------------------------*)
  (* Alle Viewport-Zeilen abarbeiten                                  *)
  (* -----------------------------------------------------------------*)
  FOR in_count := 1 TO Xus_LOG_VIEWPORT.COUNT DO

    in_index := Xus_LOG_VIEWPORT.LINE_ARRAY[in_count];

    (* -----------------------------------------------------------------*)
	(* Farbe aus den Option-Parameter auslesen >0,Level,Back,Front<     *)
    (* -----------------------------------------------------------------*)
	in_Color := DWORD_TO_INT(Xus_LOG_CONTROL.MSG_OPTION[in_index] AND DWORD#2#1111);

    CASE in_Color OF
      0..3: by_Attr := BYTE_OF_DWORD(Idw_ATTR_1,INT_TO_BYTE(in_Color));
      4..7: by_Attr := BYTE_OF_DWORD(Idw_ATTR_2,INT_TO_BYTE(in_Color));
    ELSE
	  by_Attr := BYTE_OF_DWORD(Idw_ATTR_1,BYTE#0);
    END_CASE;

    (* -----------------------------------------------------------------*)
    (* String rechts ergänzen bzw. kürzen                               *)
    (* -----------------------------------------------------------------*)
    FB_FIX.str := Xus_LOG_CONTROL.MSG[in_index];
    FB_FIX.L   := Iin_Width;
    FB_FIX.C   := BYTE#32;
    FB_FIX.M   := INT#00;
    FB_FIX();

    (* -----------------------------------------------------------------*)
    (* Message (Text + Farbe) ausgeben                                  *)
    (* -----------------------------------------------------------------*)
    FB_TN_SC_WRITE.Iin_Y			:= Iin_Y + in_count - INT#01;
    FB_TN_SC_WRITE.Iin_X			:= Iin_X;
    FB_TN_SC_WRITE.Iby_ATTR			:= by_Attr;
    FB_TN_SC_WRITE.Ist_STRING		:= FB_FIX.FIX;
    FB_TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
    FB_TN_SC_WRITE();
    Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

  END_FOR;

  (* -----------------------------------------------------------------*)
  (* Timer stoppen/rücksetzen                                         *)
  (* -----------------------------------------------------------------*)
  FB_TON.IN := FALSE;
  FB_TON.PT := Iti_TIME;
  FB_TON();

END_IF;

(* -----------------------------------------------------------------*)
(* Update-Zeitverzoegerung                                          *)
(* -----------------------------------------------------------------*)
FB_TON.IN := TRUE;
FB_TON.PT := Iti_TIME;
FB_TON();

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
