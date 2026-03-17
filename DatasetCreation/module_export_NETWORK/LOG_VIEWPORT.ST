(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)
(*
version 1.0		01 mai 2010
programmer		ks
tested BY		ks

LOG_VIEWPORT erzeugt einen Liste der Meldungen des Loggingbuffers die innerhalb einer virtuellen Ansicht enthalten sind.
*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LOG_VIEWPORT

(*Group:Parameter*)


VAR_IN_OUT
	LC :	us_LOG_CONTROL_80;
	LV :	us_LOG_VIEWPORT;
END_VAR


(*Group:lokal*)


VAR
	pos :	INT;
	count :	INT;
	idx :	INT;
	base :	INT;
	update_pos :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: LOG_VIEWPORT
IEC_LANGUAGE: ST
*)
(* Scroll Button verarbeiten *)
IF LV.MOVE_TO_X <> 0 THEN
  CASE LV.MOVE_TO_X OF
  30000:
    pos := 1 ; (* älteste Meldung anzeigen *)
  30001:
    pos := LC.SIZE; (* neueste Meldung anzeigen *)
  30002:
    pos := pos + LV.COUNT; (* eine Seite nach unten blättern -> Richtung neuere Nachrichten *)
  30003:
    pos := pos - LV.COUNT; (* eine Seite nach oben blättern -> Richtung ältere Nachrichten *)
  ELSE
    pos := pos + LV.MOVE_TO_X;
  END_CASE;
  update_pos := TRUE;
  LV.MOVE_TO_X := 0;
END_IF;

IF (LV.UPDATE_COUNT <> LC.UPDATE_COUNT) OR update_pos THEN (* Aktualisierung überwachen *)
  LV.UPDATE := TRUE;
  LV.UPDATE_COUNT := LC.UPDATE_COUNT;
  update_pos := FALSE;  

  (*-----------------------------------------------------------------------------------*)
  (* pos prüfen und übernehmen *)
  IF LC.RING_MODE THEN
    pos := LIMIT(1,pos,LC.SIZE - LV.COUNT + 1);
  ELSE
    IF LC.IDX > LV.COUNT THEN
      pos := LIMIT(1,pos,LC.IDX - LV.COUNT + 1);
    ELSE
      pos := 1;
    END_IF;
  END_IF;

  (*-----------------------------------------------------------------------------------*)
  (* idxBasis berechnen *)
  base := LC.IDX - pos - LV.COUNT + 1;
  IF LC.RING_MODE THEN 
    (* Anzeige im Ringpuffermodus *)
    FOR count:= 1 TO LV.COUNT DO
      idx := base + count;
      IF idx < 1 THEN
        idx := idx + LC.SIZE;
      END_IF;
    END_FOR;
  ELSE
    (* Anzeige im Normalmodus *)
    FOR count:= 1 TO LV.COUNT DO
      idx := base + count;
      IF idx < 1 THEN
        (* Leere Zeile ausgeben *)
        LV.LINE_ARRAY[count] := 0;
      ELSE
        LV.LINE_ARRAY[count] := idx;
      END_IF;
    END_FOR;
  END_IF;
END_IF;

(* revision history
ks	01. mai 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
