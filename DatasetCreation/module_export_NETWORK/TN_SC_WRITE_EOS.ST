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

TN_SC_WRITE_EOS schreibt einem Text an das Ende des zuletzt geschreibene Texts 

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TN_SC_WRITE_EOS

(*Group:lokal*)


VAR
	TN_SC_WRITE :	TN_SC_WRITE;
END_VAR


(*Group:IN_OUT*)


VAR_INPUT
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
TN_SC_WRITE.Iin_Y			:= Xus_TN_SCREEN.us_SYS.in_EOS_Offset / 80; (* aktuelle Zeile ausrechnen *)
TN_SC_WRITE.Iin_X			:= Xus_TN_SCREEN.us_SYS.in_EOS_Offset MOD 80; (* aktuelle Spalte ausrechnen *);
TN_SC_WRITE.Iby_ATTR		:= Iby_ATTR;
TN_SC_WRITE.Ist_STRING		:= Ist_STRING;
TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
TN_SC_WRITE();
Xus_TN_SCREEN := TN_SC_WRITE.Xus_TN_SCREEN;

(* revision history
ks	10. mai. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
