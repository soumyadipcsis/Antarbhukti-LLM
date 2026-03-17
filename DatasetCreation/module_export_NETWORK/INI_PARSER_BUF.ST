(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: FILE
*)
(*@KEY@:DESCRIPTION*)
version 1.0		23. sep. 2010
programmer 		ks
tested by		ks

INI_PARSER_BUF liefert die Elemente einer Initialisierungsdatei die in einem Bytearray abgelegt ist.

--------------------------------------

RUN Mode
00 = kein Befehl aktiv
01 = Section melden
02 = Key melden
03 = Section oder Key melden

Result Codes
01 = Section gefunden
02 = Key gefunden
05 = Befehl in Arbeit (Busy)
10 = nichts gefunden - Daten-Ende erreicht
11 = keinen Key gefunden - Section-Ende erreicht

State Codes
00 = Indexüberschreitung - Bufferende
01 = Section gefunden
02 = Key gefunden
03 = Kommentar gefunden
05 = Befehl in Arbeit (Busy)


(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK INI_PARSER_BUF

(*Group:log*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<step_last :	INT;>*)
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:lokal*)


VAR
	i :	INT;
	state :	BYTE;
	BUFFER_TO_STRING :	BUFFER_TO_STRING;
	size :	INT;
	step :	INT;
	c :	BYTE;
	k_add :	BYTE;
	v_add :	BYTE;
	eof :	BOOL;
	k_buf :	oscat_arb_0_249;
	k_idx :	INT;
	v_buf :	oscat_arb_0_249;
	v_idx :	INT;
	watchdog :	TON;
END_VAR


(*Group:Default*)


VAR_IN_OUT
	STR :	oscat_STRING250;
	RUN :	BYTE;
	OFFSET :	UDINT;
	KEY :	oscat_STRING250;
	VALUE :	oscat_STRING250;
	PT :	oscat_NETWORK_BUFFER;
END_VAR


VAR_OUTPUT
	RESULT :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: INI_PARSER_BUF
IEC_LANGUAGE: ST
*)

IF RUN > BYTE#0 THEN
	IF state = BYTE#0 THEN (* Auswertung neu beginnen *)
		VALUE := '';
		v_idx := 0;
		KEY := '';
		k_idx := 0;
		i := UDINT_TO_INT(OFFSET);
		size := UINT_TO_INT(PT.SIZE) - 1;
		RESULT := BYTE#0;
		state := BYTE#5; (* Befehl in Arbeit (Busy) *)
		step := 0; (* Auswertung neu beginnen *)
		(*####################  DEBUG-MESSAGE  ###################################*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'IPB: Startindex: ~1';
			LOG_CL.PRINTF[1]  := INT_TO_STRING(i,'%d');
			LOG_MSG();
		END_IF;*)
		(*########################################################################*)
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

			k_add := BYTE#0;
			v_add := BYTE#0;

			CASE step OF

			0: (* noch kein Modus erkannt *)
				IF c = BYTE#91 THEN (* mit "[" vergleichen *)
					step := 200; (* Modus für Section aktivieren *)
				ELSIF c = BYTE#59 OR c = BYTE#35 THEN (* mit ";" und '#' vergleichen *)
					step := 100; (* Modus für Kommentar aktivieren *)
				ELSIF c > BYTE#32 THEN (* Key erkannt *)
					k_add := c; (* Zeichen ablegen *)
					step := 300; (* Key auswertung starten *)
				END_IF;
			100: (* Kommentar erkannt -> Zeilenende suchen *)
				IF c < BYTE#32 THEN (* prüfe auf Steuerzeichen *)
					state  := BYTE#3; (* Beenden -> Kommentar wurde gefunden *)
				END_IF;
			200: (* Sections-start erkannt -> Sectionsende suchen *)
				IF c = BYTE#93 THEN (* mit "]" vergleichen *)
					IF k_idx > 0 THEN (* innerhalb von [] muss sich mindestens ein Zeichen befinden *)
						state  := BYTE#1; (* Beenden -> Section wurde gefunden *)
					ELSE
						KEY := '';
						k_idx := 0;
						step := 0; (* fehlerhafte Section-Zeile vorhanden -> weitersuchen *)
					END_IF;
				ELSIF c < BYTE#32 OR eof THEN (* Steuerzeichen - fehlerhafte Section-Zeile -> weitersuchen *)
					KEY := '';
					k_idx := 0;
					step := 0;
				ELSE
					k_add := c; (* Zeichen ablegen *)
				END_IF;
			300: (* Beginn: Key erkannt -> Name auswerten *)
				IF c < BYTE#32 THEN (* Steuerzeichen - fehlerhafte Key-Zeile -> weitersuchen *)
						KEY := '';
						k_idx := 0;
					step := 0;
				ELSIF c = BYTE#61 THEN (* prüfe auf '=' *)
					step := 330;
				ELSE
					k_add := c; (* Zeichen ablegen *)
				END_IF;
			330: (* KeyValue beginn suchen *)
				IF c < BYTE#32 THEN (* Steuerzeichen  *)
					state := BYTE#2; (* Key ohne Value gefunden *)
				ELSIF eof THEN
					state := BYTE#2; (* Key ohne Value gefunden *)
					v_add := c; (* Zeichen ablegen *)
				ELSE
					v_add := c; (* Zeichen ablegen *)
					step := 350;
				END_IF;
			350: (* KeyValue Ende suchen *)
				IF c < BYTE#32 THEN (* Steuerzeichen *)
					state := BYTE#2; (* Key gefunden *)
				ELSIF eof THEN
					v_add := c; (* Zeichen ablegen *)
					state := BYTE#2; (* Key gefunden *)
				ELSE
					v_add := c; (* Zeichen ablegen *)
				END_IF;
			END_CASE;

			IF v_add > BYTE#0 AND v_idx < 250 THEN (* Zeichen zu Value-String hinzufügen *)
				v_buf[v_idx] := v_add;
				v_idx := v_idx + 1;
			END_IF;

			IF k_add > BYTE#0 AND k_idx < 250 THEN (* Zeichen zu Key-String hinzufügen *)
				k_buf[k_idx] := k_add;
				k_idx := k_idx + 1;
			END_IF;

			i := i + 1; (* Datenzeiger erhöhen *)

		END_IF;
	END_WHILE;

	IF (state = BYTE#1 OR state = BYTE#2) AND k_idx > 0 THEN (* KEY-String ausgeben *)
		BUFFER_TO_STRING(PT:=k_buf,SIZE:=INT_TO_UINT(k_idx),START:=UINT#0,STOP:=UINT#249);
		k_buf := BUFFER_TO_STRING.PT;
		KEY   := BUFFER_TO_STRING.BUFFER_TO_STRING;
	END_IF;

	IF state = BYTE#2 AND v_idx > 0 THEN (* VALUE-String ausgeben *)
		BUFFER_TO_STRING(PT:=v_buf,SIZE:=INT_TO_UINT(v_idx),START:=UINT#0,STOP:=UINT#249);
		v_buf := BUFFER_TO_STRING.PT;
		VALUE := BUFFER_TO_STRING.BUFFER_TO_STRING;
	END_IF;

	CASE _BYTE_TO_INT(state) OF
	01:	(* Section gefunden *)
		IF RUN = BYTE#1 OR RUN = BYTE#3 THEN (* Section vorgewählt oder alles rückmelden *)
			IF EQ_STRING(KEY,STR) OR LEN(STR) = 0 THEN (* mit gesuchter Section vergleichen oder keine Section vorgegeben *)
				RESULT := BYTE#1; (* Section gefunden *)
				OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
				RUN := BYTE#0;
				state := BYTE#0;
			END_IF;
		ELSE
			KEY := '';
			k_idx := 0;
			RESULT := BYTE#11; (* Key nicht gefunden , Section-Ende - Offset nicht verändern *)
			RUN := BYTE#0;
			state := BYTE#0;
		END_IF;
	02:	(* Key gefunden *)
		IF RUN = BYTE#2 OR RUN = BYTE#3 THEN (* Key vorgewählt oder alles rückmelden *)
			IF EQ_STRING(KEY,STR) OR LEN(STR) = 0 THEN (* mit gesuchten Key vergleichen *)
				RESULT := BYTE#2; (* Key gefunden *)
				OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
				RUN := BYTE#0;
				state := BYTE#0;
			END_IF;
		END_IF;
	03:	(* Kommenar gefunden *)
		OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
		state := BYTE#0;

	05:	RESULT := BYTE#5; (* in Arbeit *)

	10:	(* Indexüberschreitung - Bufferende *)
		RESULT := BYTE#10; (* nichts gefunden - Datenende erreicht *)
		OFFSET := INT_TO_UDINT(i); (* Offset uebernehmen *)
		RUN := BYTE#0;
		state := BYTE#0;
	END_CASE;
	(*####################  DEBUG-MESSAGE  ###################################*)
	(*IF _debug_enable THEN
		LOG_CL.NEW_MSG := 'IPF: intern Result ~1 , state ~2, step ~3 , offset ~4, run ~5';
		LOG_CL.PRINTF[1] := BYTE_TO_STRING(RESULT,'%u');
		LOG_CL.PRINTF[2] := BYTE_TO_STRING(state,'%u');
		LOG_CL.PRINTF[3] := INT_TO_STRING(step,'%d');
		LOG_CL.PRINTF[4] := UDINT_TO_STRING(OFFSET,'%u');
		LOG_CL.PRINTF[5] := BYTE_TO_STRING(RUN,'%u');
		LOG_MSG();
	END_IF;*)
	(*########################################################################*)
END_IF;

(*####################  DEBUG-MESSAGE  ###################################*)
(*IF _debug_enable THEN
	IF step_last <> step THEN
		LOG_CL.NEW_MSG := 'IPB: Step: ~1';
		LOG_CL.PRINTF[1]  := INT_TO_STRING(step,'%d');
		LOG_MSG();
	END_IF;
	step_last := step;
END_IF;*)
(*########################################################################*)

(* revision history
ks	23. sep. 2010	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
