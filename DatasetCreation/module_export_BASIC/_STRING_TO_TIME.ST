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
FUNCTION_BLOCK _STRING_TO_TIME

(*Group:Default*)


VAR_INPUT
	_TIME :	STRING;
END_VAR


VAR_OUTPUT
	STRING_TO_TIME :	TIME;
END_VAR


VAR
	pos1 :	INT;
	pos2 :	INT;
	tmp :	oscat_STRING20;
	tmp2 :	oscat_STRING20;
	UPPERCASE :	UPPERCASE;
	FINDB_NONUM :	FINDB_NONUM;
	FINDB_NUM :	FINDB_NUM;
	faktor :	UDINT;
	IS_ALNUM :	IS_ALNUM;
END_VAR


(*@KEY@: WORKSHEET
NAME: _STRING_TO_TIME
IEC_LANGUAGE: ST
*)
(*
TIME-Konstanten

Eine TIME-Konstante besteht stets aus einem anführenden "t" oder "T" (bzw. "time" oder "TIME" in der ausführlichen Form) und einem Doppelkreuz "#".
Danach kommt die eigentliche Zeitdeklaration, diese kann bestehen aus Tagen (bezeichnet mit "d"), Stunden (bezeichnet mit "h"), Minuten (bezeichnet mit "m"), Sekunden (bezeichnet mit "s") und Millisekunden (bezeichnet mit "ms"). Es ist zu beachten, daß die Zeitangaben der Größe nach geordnet sein mü
ssen (d vor h vor m vor s vor m vor ms), wobei nicht alle Zeitangaben verwendet werden müssen.

Maximaler Wert: 49d17h2m47s295ms (4194967295 ms)

Beispiele für korrekte TIME-Konstanten in einer ST-Zuweisung:
TIME1 := T#14ms;
TIME1 := T#100S12ms;

Überlauf in der höchsten Komponente ist erlaubt
TIME1 := t#12h34m15s;
*)

UPPERCASE(str:=_TIME);
tmp:=UPPERCASE.UPPERCASE;

STRING_TO_TIME := T#0s;

WHILE (TRUE) DO
  FAKTOR := UDINT#0;

  FINDB_NONUM(str:=tmp);
  pos2:=FINDB_NONUM.findB_nonum;

  FINDB_NUM(str:=tmp);
  pos1:=FINDB_NUM.findB_num;

  (* bezeichner gefunden *)
  IF POS1>0 AND (POS2>POS1) THEN

    tmp2 := RIGHT(tmp,POS2-POS1);
    tmp := LEFT(tmp,pos1);

    IF EQ_STRING(tmp2,'MS') THEN
	  FAKTOR := UDINT#1;
    ELSIF EQ_STRING(tmp2,'S') THEN
	  FAKTOR := UDINT#1000;
    ELSIF EQ_STRING(tmp2,'M') THEN
	  FAKTOR := UDINT#60000;
    ELSIF EQ_STRING(tmp2,'H') THEN
	  FAKTOR := UDINT#3600000;
    ELSIF EQ_STRING(tmp2,'D') THEN
	  FAKTOR := UDINT#864000000;
    END_IF;
  ELSE
    EXIT;
  END_IF;

  IF FAKTOR > UDINT#0 THEN

    FINDB_NONUM(str:=tmp);
    pos1:=FINDB_NONUM.findB_nonum;
    IF pos1>0 THEN
      tmp2 := RIGHT(tmp,LEN(tmp)-pos1);
      tmp := LEFT(tmp,pos1);
      IS_ALNUM(str:=tmp2);
      IF IS_ALNUM.IS_ALNUM THEN
        STRING_TO_TIME := STRING_TO_TIME + UDINT_TO_TIME(faktor * STRING_TO_UDINT(tmp2));
      END_IF;
    ELSE
	  EXIT;
    END_IF;
  END_IF;
END_WHILE;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
