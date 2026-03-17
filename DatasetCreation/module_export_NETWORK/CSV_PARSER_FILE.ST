(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: FILE
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CSV_PARSER_FILE

(*Group:log*)


VAR
	(*<CHR_TO_STRING :	CHR_TO_STRING;>*)
	(*<BOOL_TO_STRING :	BOOL_TO_STRING;>*)
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<step_last :	INT;>*)
	(*<_debug_enable :	BOOL;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
END_VAR


VAR_IN_OUT
	FILENAME :	STRING;
	FSD :	oscat_FILE_SERVER_DATA;
	RUN :	BYTE;
	OFFSET :	UDINT;
	VALUE :	oscat_STRING250;
	PT :	oscat_NETWORK_BUFFER;
END_VAR


VAR_OUTPUT
	RESULT :	BYTE;
END_VAR


VAR
	FB :	FILE_BLOCK;
	i :	UDINT;
	state :	BYTE;
	e :	BYTE;
	mode :	BYTE;
	step :	INT;
	c :	BYTE;
	v_add :	BYTE;
	v_idx :	INT;
	v_buf :	oscat_arb_0_249;
	BUFFER_TO_STRING :	BUFFER_TO_STRING;
	eof :	BOOL;
	watchdog :	TON;
	x :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CSV_PARSER_FILE
IEC_LANGUAGE: ST
*)

IF RUN > BYTE#0 THEN

	IF state = BYTE#0 THEN (* Auswertung neu beginnen *)
		VALUE := '';
		v_idx := 0;
		i := OFFSET;
		RESULT := BYTE#0;
		state := BYTE#5; (* Befehl in Arbeit (Busy) *)
		step := 0; (* Auswertung neu beginnen *)

		(* ---------------- Debug-Message -----------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'CPF: Startindex: ~1';
			LOG_CL.PRINTF[1] := UDINT_TO_STRING(i,'%d');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)

	END_IF;

	watchdog(IN:=FALSE,PT:=T#1ms); (* Timer neustarten *)
	watchdog.IN := TRUE;

	WHILE (state = BYTE#5) DO (* Schleife solange kein Ergebnis *)

		mode := BYTE#1;
		FB(MODE:=mode,FSD:=fsd,PT:=PT,FILENAME:=FILENAME,POS:=i);
		FILENAME:=FB.FILENAME;
		mode:=FB.MODE;
		fsd:=FB.FSD;
		PT:=FB.PT;
		e:=FB.ERROR;
		c:=FB.DATA;

		eof := i + UDINT#1 = FSD.FILE_SIZE; (* End of File *)
		(* ---------------- Debug-Message -----------------------*)
		(*IF _debug_enable THEN
			CHR_TO_STRING(C:=c);
			BOOL_TO_STRING(IN:=eof);

			LOG_CL.NEW_MSG := 'IPF: mode: ~1, error: ~2 , >~7<>~3< ~4 step ~5 index ~6';
			LOG_CL.PRINTF[1] := BYTE_TO_STRING(mode,'%u');
			LOG_CL.PRINTF[2] := BYTE_TO_STRING(e,'%u');
			LOG_CL.PRINTF[3] := BYTE_TO_STRING(c,'%u');
			LOG_CL.PRINTF[4] := BOOL_TO_STRING.BOOL_TO_STRING;
			LOG_CL.PRINTF[5] := INT_TO_STRING(step,'%d');
			LOG_CL.PRINTF[6] := UDINT_TO_STRING(i,'%u');
			LOG_CL.PRINTF[7] := CHR_TO_STRING.CHR_TO_STRING;
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
		watchdog(); (* Timer aktualisieren *)

		IF mode > BYTE#0 OR watchdog.Q THEN (* Baustein noch aktiv, oder watchdog ausgelöst *)
			state := BYTE#5;
			EXIT;
		ELSIF e > BYTE#0 THEN (* File_error oder kein weiteres zeichen vorhanden *)
			state := BYTE#10; (* nichts gefunden - Daten-Ende erreicht *)
			EXIT;
		ELSE

			v_add := BYTE#0;

			IF c = SEP THEN (* Neues Element erkannt *)
				state := BYTE#1;
				x := TRUE;
			ELSIF c >= BYTE#32 THEN (* Element erkannt *)
				v_add := c; (* Zeichen ablegen *)
				IF eof THEN
					state := BYTE#2; (* Element und Zeilenende erkannt *)
				ELSE
					x := TRUE;
				END_IF;
			ELSE
				IF x THEN
					state := BYTE#2; (* Element und Zeilenende erkannt *)
					x := FALSE;
				END_IF;
			END_IF;

			IF v_add > BYTE#0 AND v_idx < 250 THEN (* Zeichen zu Value-String hinzufügen *)
				v_buf[v_idx] := v_add;
				v_idx := v_idx + 1;
			END_IF;

			i := i + UDINT#1; (* Datenzeiger erhöhen *)

		END_IF;
	END_WHILE;

	IF (state = BYTE#1 OR state = BYTE#2) AND v_idx > 0 THEN (* VALUE-String ausgeben *)
		BUFFER_TO_STRING(PT:=v_buf,SIZE:=INT_TO_UINT(v_idx),START:=UINT#0,STOP:=UINT#249);
		v_buf := BUFFER_TO_STRING.PT;
		VALUE := BUFFER_TO_STRING.BUFFER_TO_STRING;
	END_IF;

	CASE _BYTE_TO_INT(state) OF
	01:	(* Element gefunden *)
		RESULT := BYTE#1; (* Element gefunden *)
		OFFSET := i; (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;
	02:	(* Element gefunden *)
		RESULT := BYTE#2; (* Element und Zeilenende erkannt *)
		OFFSET := i; (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;

	05:	RESULT := BYTE#5; (* in Arbeit *)

	10:	(* Indexüberschreitung - Bufferende *)
		RESULT := BYTE#10; (* nichts gefunden - Datenende erreicht *)
		OFFSET := i; (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;
	END_CASE;

	(* ---------------- Debug-Message -----------------------*)
	(*IF _debug_enable THEN
		LOG_CL.NEW_MSG := 'CPF: intern Result ~1 , state ~2, step ~3 , offset ~4, run ~5';
		LOG_CL.PRINTF[1] := BYTE_TO_STRING(RESULT,'%u');
		LOG_CL.PRINTF[2] := BYTE_TO_STRING(state,'%u');
		LOG_CL.PRINTF[3] := INT_TO_STRING(step,'%d');
		LOG_CL.PRINTF[4] := UDINT_TO_STRING(OFFSET,'%u');
		LOG_CL.PRINTF[5] := BYTE_TO_STRING(RUN,'%u');
		LOG_MSG();
	END_IF;*)
	(* -----------------------------------------------------------------*)

END_IF;

(* ---------------- Debug-Message -----------------------*)
(*IF _debug_enable THEN
	IF step_last <> step THEN
		LOG_CL.NEW_MSG := 'CPF: Step: ~1';
		LOG_CL.PRINTF[1]  := INT_TO_STRING(step,'%d');
		LOG_MSG();
	END_IF;
	step_last := step;
END_IF;*)
(* -----------------------------------------------------------------*)

(* revision history
ks	01. oct. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
