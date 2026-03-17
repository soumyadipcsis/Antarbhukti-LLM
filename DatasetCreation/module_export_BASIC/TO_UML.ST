(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	17. dec. 2008
programmer 		hugo
tested by		tobias

to_uml converts a character above 127 to a two digit character below 127.
the character Ä is converted to Ae
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TO_UML

(*Group:Default*)


VAR_INPUT
	IN :	BYTE;
END_VAR


VAR_OUTPUT
	TO_UML :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: TO_UML
IEC_LANGUAGE: ST
*)
CASE _BYTE_TO_INT(in) OF
	196:	(* Ä *)
		TO_UML := 'Ae';
	214:	(* Ö *)
		TO_UML := 'Oe';
	220:	(* Ü *)
		TO_UML := 'Ue';
	223:	(* ß *)
		TO_UML := 'ss';
	228:	(* ä *)
		TO_UML := 'ae';
	246:	(* ö *)
		TO_UML := 'oe';
	252:	(* ü *)
		TO_UML := 'ue';
ELSE
	TO_UML := BYTE_TO_STRING(IN,'%c');
END_CASE;



(* revision history
hm	29. mar. 2008	rev 1.0
	original version

hm	17. dec. 2008	rev 1.1
	changes name of function chr to chr_to_string

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
