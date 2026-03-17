(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.4	10. mar. 2009
programmer 	hugo
tested by	tobias

this function return true if the real input is negative
(*@KEY@:END_DESCRIPTION*)
FUNCTION SIGN_R:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SIGN_R
IEC_LANGUAGE: ST
*)
SIGN_R := in < 0.0;


(* revision history
hm 19.1.2007	rev 1.1
	changed method of function for better compatibility to other systems

hm	1.12.2007	rev 1.2
	changed code to improve performance

hm	14. jun. 2008	rev 1.3
	improved performace

hm 10. mar. 2009	rev 1.4
	real constants updated to new systax using dot																																																															
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																																											
																																																								

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
