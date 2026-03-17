(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.0		01. mai 2010
programmer 		ks
tested by		ks

LOG_MSG_80 trägt Meldungen in den Loggingbuffer ein

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LOG_MSG_80

(*Group:Log*)


VAR_EXTERNAL
	LOG_CL_80 :	us_LOG_CONTROL_80;
END_VAR


VAR
	FB_PRINT_SF_80 :	PRINT_SF_80;
END_VAR


(*Group:Variablen*)


VAR
	idx :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LOG_MSG_80
IEC_LANGUAGE: ST
*)
IF DWORD_TO_BYTE(SHL(LOG_CL_80.NEW_MSG_OPTION,16)) > LOG_CL_80.LEVEL THEN RETURN; END_IF; (* Logging freigegeben ?*)
LOG_CL_80.SIZE := 400; (* workaround - keine initialswerte bei datenstrukturen möglich *)

FB_PRINT_SF_80.PRINTF_DATA := LOG_CL_80.PRINTF; (* Printf Parameter übergeben *)
FB_PRINT_SF_80.STR := LOG_CL_80.NEW_MSG; (* Message übergeben *)
FB_PRINT_SF_80();
LOG_CL_80.NEW_MSG := FB_PRINT_SF_80.STR; (* Message übernehmen *)
LOG_CL_80.PRINTF := FB_PRINT_SF_80.PRINTF_DATA;

IF LOG_CL_80.RESET THEN (* Logeinträge löschen *)
  LOG_CL_80.RESET := FALSE;
  LOG_CL_80.RING_MODE := FALSE;
  LOG_CL_80.IDX := 0;
  LOG_CL_80.UPDATE_COUNT := LOG_CL_80.UPDATE_COUNT + UINT#1; (* UpdateCount erhöhen                 *)  
END_IF;

(* Meldung in Puffer eintragen         *)
IF LEN(LOG_CL_80.NEW_MSG) > 0 THEN 
  IF (LOG_CL_80.IDX >= LOG_CL_80.SIZE) THEN
    LOG_CL_80.RING_MODE := TRUE; (* bei Überlauf = Ringbuffermodus       *)
    LOG_CL_80.IDX := 0; (* wieder auf arrayanfang positionieren *)
  END_IF;

  LOG_CL_80.UPDATE_COUNT := LOG_CL_80.UPDATE_COUNT + UINT#1; (* UpdateCount erhöhen *)
  LOG_CL_80.IDX := LOG_CL_80.IDX + INT#1; (* nächste freie Position *)
  idx := LOG_CL_80.IDX; (* lade aktuelle Log-Puffer Positition *)
  LOG_CL_80.MSG[idx] := LOG_CL_80.NEW_MSG; (* neuen Log-String in puffer ablegen  *)
  LOG_CL_80.MSG_OPTION[idx] := LOG_CL_80.NEW_MSG_OPTION; (* neue Log-String Option in puffer ablegen  *)
  LOG_CL_80.NEW_MSG := ''; (* letzten Log-String löschen *)

END_IF;

(* revision history
ks	01. mai 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
