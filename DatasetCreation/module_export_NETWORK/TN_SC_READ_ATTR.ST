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

TN_SC_READ_ATTR gibt den Farbcode einer Koordinate vom Bildschirm aus

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_READ_ATTR

(*Group:instances*)


(*Group:lokal*)


VAR
	in_Offset :	INT;
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
	Iin_Y :	INT;
	Iin_X :	INT;
END_VAR


VAR_OUTPUT
	Oby_ATTR :	BYTE;
END_VAR


VAR_IN_OUT
	Xus_TN_SCREEN :	us_TN_SCREEN;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
IF TN_SC_XY_ERROR(Iin_X,Iin_Y) THEN RETURN; END_IF;
in_Offset := (Iin_Y * 80) + Iin_X;
Oby_ATTR := Xus_TN_SCREEN.bya_COLOR[in_Offset]; (* Attribute auslesen *)

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
