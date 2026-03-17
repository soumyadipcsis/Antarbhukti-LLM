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
FUNCTION_BLOCK STRING_TO_TOD

(*Group:Default*)


VAR_INPUT
	_TOD :	STRING;
END_VAR


VAR_OUTPUT
	STRING_TO_TOD :	UDINT;
END_VAR


VAR
	pos :	INT;
	i :	INT;
	tmp :	STRING;
	tmp2 :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: STRING_TO_TOD
IEC_LANGUAGE: ST
*)
(*
TIME_OF_DAY-Konstanten, zum Speichern von Uhrzeiten:

Eine TIME_OF_DAY-Deklaration beginnt mit "tod#", "TOD#", "TIME_OF_DAY#"
oder "time_of_day#", anschließend können Sie eine Uhrzeit angeben in der Schreibweise:
Stunde:Minute:Sekunde. Sekunden können dabei als reelle Zahlen angegeben werden,
es können also auch Sekundenbruchteile angegeben werden.
Mögliche Werte: 00:00:00 bis 23:59:59.999.

Beispiele:

TIME_OF_DAY#15:36:30.123

tod#00:00:00
*)

STRING_TO_TOD := UDINT#0;
i := LEN(_TOD);
pos :=FIND(_TOD,'#');

IF pos>0 AND i>pos THEN
  tmp := RIGHT(_TOD,LEN(_TOD)-pos);
  pos := FIND(tmp,':');
  IF pos>1 THEN
    tmp2 := LEFT(tmp,pos-1);
    tmp := RIGHT(tmp,LEN(tmp)-pos);
    STRING_TO_TOD := STRING_TO_UDINT(tmp2) * UDINT#3600000;

    pos :=FIND(tmp,':');
    IF pos>1 THEN
      tmp2 := LEFT(tmp,pos-1);
      tmp := RIGHT(tmp,LEN(tmp)-pos);
      STRING_TO_TOD := STRING_TO_TOD + STRING_TO_UDINT(tmp2) * UDINT#60000;

      STRING_TO_TOD := STRING_TO_TOD + STRING_TO_UDINT(tmp) * UDINT#1000;
    END_IF;
  END_IF;
END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
