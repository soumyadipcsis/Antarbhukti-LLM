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

LOG_MSG trägt Meldungen in den Loggingbuffer ein

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LOG_MSG

(*Group:Log*)


VAR_EXTERNAL
	LOG_CL :	us_LOG_CONTROL;
END_VAR


(*Group:Variablen*)


VAR
	FB_PRINT_SF :	PRINT_SF;
	idx :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LOG_MSG
IEC_LANGUAGE: ST
*)
IF DWORD_TO_BYTE(SHL(LOG_CL.NEW_MSG_OPTION,16)) > LOG_CL.LEVEL THEN RETURN; END_IF; (* Logging freigegeben ?*)
LOG_CL.SIZE := 400; (* workaround - keine initialswerte bei datenstrukturen möglich *)

FB_PRINT_SF.PRINTF_DATA := LOG_CL.PRINTF; (* Printf Parameter übergeben   *)
FB_PRINT_SF.STR 		:= LOG_CL.NEW_MSG; (* Message übergeben *)
FB_PRINT_SF();
LOG_CL.NEW_MSG	:= FB_PRINT_SF.STR; (* Message übernehmen *)
LOG_CL.PRINTF	:= FB_PRINT_SF.PRINTF_DATA;

IF LOG_CL.RESET THEN (* Logeinträge löschen *)
	LOG_CL.RESET := FALSE;
	LOG_CL.RING_MODE := FALSE;
	LOG_CL.IDX := 0;
	LOG_CL.UPDATE_COUNT := LOG_CL.UPDATE_COUNT + UINT#1; (* UpdateCount erhöhen *)  
END_IF;

IF LOG_CL.SIZE > 0 THEN (* size wert ist eingetragen *)
	IF LEN(LOG_CL.NEW_MSG) > 0 THEN (* Meldung in Puffer eintragen *)
		IF (LOG_CL.IDX >= LOG_CL.SIZE) THEN
			LOG_CL.RING_MODE := TRUE; (* bei Überlauf = Ringbuffermodus *)
			LOG_CL.IDX := 0; (* wieder auf arrayanfang positionieren *)
		END_IF;

		LOG_CL.UPDATE_COUNT := LOG_CL.UPDATE_COUNT + UINT#1; (* UpdateCount erhöhen *)
		LOG_CL.IDX := LOG_CL.IDX + INT#1; (* nächste freie Position *)
		idx := LOG_CL.IDX; (* lade aktuelle Log-Puffer Positition *)
		LOG_CL.MSG[idx] := LOG_CL.NEW_MSG; (* neuen Log-String in puffer ablegen  *)
		LOG_CL.MSG_OPTION[idx] := LOG_CL.NEW_MSG_OPTION; (* neue Log-String Option in puffer ablegen  *)
		LOG_CL.NEW_MSG := ''; (* letzten Log-String löschen *)

	END_IF;
END_IF;

(* revision history
ks	01. mai 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
