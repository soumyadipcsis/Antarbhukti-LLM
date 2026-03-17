(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: EMULATION
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _INSERT80

(*Group:Default*)


VAR_INPUT
	IN1 :	STRING;(*Eingangszeichenfolge*)
	IN2 :	STRING;(*Einfügestring*)
	P :	INT;(*Einfügeposition*)
END_VAR


VAR_OUTPUT
	_INSERT :	STRING;(*Ergebnis*)
END_VAR


VAR
	size :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _INSERT80
IEC_LANGUAGE: ST
*)
size := LEN(IN1);
IF size + LEN(IN2) <= 80 THEN
    P := LIMIT(0,P,size);
    IF P = 0 THEN
        _INSERT := CONCAT(IN2,IN1);
    ELSE
        _INSERT := INSERT(IN1, IN2, P);
    END_IF;
END_IF;

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
