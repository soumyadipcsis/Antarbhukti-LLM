(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: FILE
*)
(*@KEY@:DESCRIPTION*)
version 1.0		01. oct. 2010
programmer 		ks
tested by		ks

CSV_PARSER_BUF liefert die Elemente oder Zeilen einer Textdatei die in einem Bytearray abgelegt ist.

--------------------------------------

RUN Mode
00 = kein Befehl aktiv
01 = Element suchen

Result Codes
01 = Element gefunden
02 = Element und Zeilenende erkannt
05 = Befehl in Arbeit (Busy)
10 = nichts gefunden - Daten-Ende erreicht

State Codes
01 = Element gefunden
02 = Element und Zeilenende erkannt
03 = Kommentar gefunden
05 = Befehl in Arbeit (Busy)
10 = nichts gefunden - Daten-Ende erreicht

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK CSV_PARSER_BUF

(*Group:log*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<step_last :	INT;>*)
	(*<_debug_enable :	BOOL := FALSE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:Default*)


VAR_INPUT
	SEP :	BYTE;
END_VAR


VAR_IN_OUT
	RUN :	BYTE;
	OFFSET :	UDINT;
	VALUE :	oscat_STRING250;
	PT :	oscat_NETWORK_BUFFER;
END_VAR


VAR_OUTPUT
	RESULT :	BYTE;
END_VAR


VAR
	step :	INT;
	size :	INT;
	c :	BYTE;
	v_add :	BYTE;
	v_idx :	INT;
	v_buf :	oscat_arb_0_249;
	BUFFER_TO_STRING :	BUFFER_TO_STRING;
	i :	INT;
	state :	BYTE;
	eof :	BOOL;
	watchdog :	TON;
	x :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: CSV_PARSER_BUF
IEC_LANGUAGE: ST
*)

IF RUN > BYTE#0 THEN
	IF state = BYTE#0 THEN (* Auswertung neu beginnen *)
		VALUE := '';
		v_idx := 0;
		i := UDINT_TO_INT(OFFSET);
		size := UINT_TO_INT(PT.SIZE) - 1;
		RESULT := BYTE#0;
		state := BYTE#5; (* Befehl in Arbeit (Busy) *)
		step := 0; (* Auswertung neu beginnen *)

		(* ---------------- Debug-Message -----------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'CPF: Startindex: ~1';
			LOG_CL.PRINTF[1] := INT_TO_STRING(i,'%d');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)

	END_IF;

	watchdog(IN:=FALSE,PT:=T#1ms); (* Timer neustarten *)
	watchdog.IN := TRUE;

	WHILE (state = BYTE#5) DO (* Schleife solange kein Ergebnis *)

		watchdog(); (* Timer aktualisieren *)

		IF watchdog.Q THEN (* watchdog ausgelöst *)
			state := BYTE#5;
			EXIT;
		ELSIF i > size THEN (* kein weiteres zeichen vorhanden *)
			state := BYTE#10; (* nichts gefunden - Daten-Ende erreicht *)
			EXIT;
		ELSE

			c := PT.BUFFER[i]; (* neues Zeichen aus Buffer lesen *)
			eof := INT_TO_UINT(i + 1) = PT.SIZE; (* End of File *)

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

			i := i + 1; (* Datenzeiger erhöhen *)

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
		OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;
	02:	(* Element gefunden *)
		RESULT := BYTE#2; (* Element und Zeilenende erkannt *)
		OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;

	05:	RESULT := BYTE#5; (* in Arbeit *)

	10:	(* Indexüberschreitung - Bufferende *)
		RESULT := BYTE#10; (* nichts gefunden - Datenende erreicht *)
		OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;
	END_CASE;

	(* ---------------- Debug-Message -----------------------*)
	(*IF _debug_enable THEN
		LOG_CL.NEW_MSG := 'CPF: intern Result ~1 , state ~2, step ~3 , offset ~4, run ~5';
		LOG_CL.PRINTF[1] := BYTE_TO_STRING(RESULT,'%u');
		LOG_CL.PRINTF[2] := BYTE_TO_STRING(state,'%u');
		LOG_CL.PRINTF[3] := INT_TO_STRING(step,'%d');
		LOG_CL.PRINTF[4] := UDINT_TO_STRING(OFFSET,'%d');
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
