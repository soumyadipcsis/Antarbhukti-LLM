(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.0		27. apr. 2008
programmer 		hugo
tested by		hugo

IS_URL_CHR is true if a string contains only non reserved characters for an url.
the non reserved characters are : [A..Z], [a..z], [0..9], -_.~
(*@KEY@:END_DESCRIPTION*)
FUNCTION IS_URLCHR:BOOL

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: IS_URLCHR
IEC_LANGUAGE: ST
*)
IS_URLCHR := ((IN>BYTE#47) AND (IN<BYTE#58)) OR ((IN>BYTE#64) AND (IN<BYTE#91)) OR ((IN>BYTE#96) AND (IN<BYTE#123)) OR (in=BYTE#126) OR (in=BYTE#95) OR (in=BYTE#45) OR (in=BYTE#46);


(* revision history
hm		27. apr. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
