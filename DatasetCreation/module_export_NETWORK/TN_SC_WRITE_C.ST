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

TN_SC_WRITE_C korrigiert die Textlänge und schreibt den Text an die angegebenen Koordinate

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_WRITE_C

(*Group:lokal*)


(*Group:instances*)


VAR
	FB_FIX :	FIX;
	FB_TN_SC_WRITE :	TN_SC_WRITE;
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
	Iin_Y :	INT;
	Iin_X :	INT;
	Iby_ATTR :	BYTE;
	Ist_STRING :	STRING;
	Iin_LENGTH :	INT;
	Iin_OPTION :	INT;
END_VAR


VAR_IN_OUT
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
(* --------------------------------------------------------------------*)
(* Text aufbereiten (Länge und Ausrichtung)                            *)
(* --------------------------------------------------------------------*)
FB_FIX.str:=Ist_STRING;
FB_FIX.L:=Iin_LENGTH;
FB_FIX.C:=BYTE#32;
FB_FIX.M:=Iin_OPTION;
FB_FIX();

(* -----------------------------------------------------------------*)
(* Text ausgeben                                                    *)
(* -----------------------------------------------------------------*)
FB_TN_SC_WRITE.Iin_Y			:= Iin_Y;
FB_TN_SC_WRITE.Iin_X			:= Iin_X;
FB_TN_SC_WRITE.Iby_ATTR			:= Iby_ATTR;
FB_TN_SC_WRITE.Ist_STRING		:= FB_FIX.FIX;
FB_TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
FB_TN_SC_WRITE();
Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
