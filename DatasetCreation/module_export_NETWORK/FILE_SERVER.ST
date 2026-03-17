(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HARDWARE
*)
(*@KEY@:DESCRIPTION*)
version 1.0		23. sep. 2010
programmer 		ks
tested by		ks

FILE_SERVER ermöglicht den Zugriff auf Dateien mittels Plattform-Neutraler Schnittstelle

Befehle:
1 = File_Open_Exist + File_Read
2 = File_Open_Exist + File_Write
3 = File_Open_New   + File_Write
4 = File_Remove
5 = File_Close

- Action -
1 = file_open   (open)
2 = file_close  (close)
3 = file_read   (read)
4 = file_write  (write)
5 = file_seek   (setpos)
6 = file_tell   (getpos)
7 = file_remove (delete)

---- fehlermeldungen----

000 (00) kein Fehler

002 (02) file_open - Die maximale Anzahl von Dateien ist bereits geöffnet.
004 (04) file_open - Die Datei ist bereits geöffnet.
005 (05) file_open - Die Datei ist schreibgeschützt oder Zugriff verweigert.
006 (06) file_open - Dateiname nicht angegeben.

011 (01) file_close - Ungültiger Dateihandle.
030 (20) file_close - Datei konnte nicht geschlossen werden.

041 (01) file_read - Ungültiger Dateihandle.
050 (10) file_read - Dateiende erreicht.
052 (12) file_read - Die Anzahl der zu lesenden Zeichen ist größer als der Datenpuffer.
062 (22) file_read - Es konnten keine Daten gelesen werden.

071 (01) file_write - Ungültiger Dateihandle.
081 (11) file_write - Es ist kein Speicher zum Schreiben der Daten verfügbar.
082 (12) file_write - Die Anzahl der zu schreibenden Zeichen ist größer als der Datenpuffer.
093 (23) file_write - Es konnten keine Daten geschrieben werden.

101 (01) file_seek - Ungültiger Dateihandle.
113 (13) file_seek - Ungültiger Positionierungsmodus oder die angegebene Position liegt vor dem Dateianfang.
124 (24) file_seek - Die Position konnte nicht gesetzt werden.

131 (01) file_tell - Ungültiger Dateihandle.

142 (02) file_remove - Die maximale Anzahl von Dateien ist bereits geöffnet.
143 (03) file_remove - Die Datei konnte nicht gefunden werden.
145 (05) file_remove - Die Datei ist geöffnet, schreibgeschützt oder Zugriff verweigert.
146 (06) file_remove - Dateiname nicht angegeben.
161 (21) file_remove - Datei konnte nicht gelöscht werden.

255: Position liegt hinter dem Dateiende (Applikationserror)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILE_SERVER

(*Group:neu*)


VAR
	buf_size :	UDINT := UDINT#4096;
	handle :	UINT;(*Filehandle*)
	read_max_length :	UDINT;(*maximale Datenlänge*)
	file_position :	UDINT;(*aktueller Schreib/Lesezeiger*)
	used_filename :	STRING;(*aktueller Dateiname*)
	close_time :	TIME;
	length_read :	UDINT;
	write_length :	UDINT;
	length_written :	UDINT;
	open_handle :	UINT;
	seek_mode :	UINT;
	seek_position :	UDINT;
	tell_position :	UDINT;
END_VAR


(*Group:lokal*)


VAR
	last_mode :	BYTE;
	command :	BYTE;
	error_code :	BYTE;
	error :	BOOL;
	file_change :	BOOL;
	step :	INT;
	t_diff :	TIME;
	tx_last :	TIME;
	tx :	TIME;
END_VAR


(*Group:parameter*)


VAR_IN_OUT
	FSD :	oscat_FILE_SERVER_DATA;
	PT :	oscat_NETWORK_BUFFER;
END_VAR


(*Group:log*)


VAR
	(*<_debug_enable :	BOOL := TRUE;>*)
	(*<step_last :	INT;>*)
	(*<LOG_MSG :	LOG_MSG;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:Instance*)


VAR
	FILE_REMOVE :	FILE_REMOVE;
	FILE_OPEN :	FILE_OPEN;
	FILE_SEEK :	FILE_SEEK;
	FILE_TELL :	FILE_TELL;
	FILE_CLOSE :	FILE_CLOSE;
	FILE_READ :	FILE_READ;
	FILE_WRITE :	FILE_WRITE;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILE_SERVER
IEC_LANGUAGE: ST
*)
(* read system timer *)
T_PLC_MS();
tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
t_diff := tx - tx_last;
tx_last := tx;

CASE step OF
0:
	IF FSD.MODE = LIMIT(BYTE#1,FSD.MODE,BYTE#5) THEN
   		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'File_Start Mode=~1';
			LOG_CL.PRINTF[1] := BYTE_TO_STRING (FSD.MODE,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
		close_time := T#1ms; (* wenn Schritt aktiv ist, dann Close-Timer rücksetzen *)
		IF handle = UINT#00 AND FSD.MODE <= BYTE#3 THEN (* Mode 1,2,3 und file nicht geöffnet *)
			step := 100; (* File muss erst geöffnet werden *)
		ELSE
			(* File ist schon geöffnet - alten und neuen Filenamen vergleichen *) 
			IF EQ_STRING(used_filename, FSD.FILENAME) AND FSD.MODE = last_mode THEN (* kein Moduswechsel ? *)
				step := 200; (* ohne open prozedure weitermachen *)
			ELSE
				step := 32000; (* (* mode 3,4,5 - File_Close ausführen *)
				file_change := FSD.MODE <> BYTE#5; (* mode 5 - File_close ausschliessen *)
			END_IF;
		END_IF;
	ELSIF handle > UINT#0 THEN (* offene Datei gefunden - AutoClose Modus *)
		IF FSD.AUTO_CLOSE > T#0s THEN
			close_time := close_time + t_diff; (* Close_Time hochzählen *)
			IF close_time > FSD.AUTO_CLOSE THEN (* Zeit überschrittenen *)
				step := 32000; (* automatisch Datei schliessen *)
			END_IF;
		END_IF;
	END_IF;

100:
	IF FSD.MODE = BYTE#3 OR FSD.MODE = BYTE#4 THEN
		command := BYTE#7; (* File Remove *)
		step := 110;
	ELSE
		step := 120; (* File Open ausführen *)
	END_IF;

110: (* File Remove *) 
	IF command = BYTE#0  THEN
		IF (FSD.MODE = BYTE#4) OR (error and error_code <> BYTE#143) THEN (* Mode: File Remove *)
			step := 30000; (* Beenden *)
		ELSE
			step := 120;
		END_IF;
	END_IF;

120:
	command := BYTE#1; (* File Open *)
	last_mode := FSD.MODE;
	step := 122;

122: (* File Open *)
	IF command = BYTE#0 THEN
		IF error THEN
			step := 30000; (* Beenden *)
		ELSE
			(* Filedaten eintragen *)
			close_time := T#1ms; (* Timer freigeben *)
			handle := open_handle;
			used_filename := FSD.FILENAME;
			file_position := UDINT#4294967295; (* maximal = unbekannt *)
			FSD.FILE_SIZE := UDINT#0;
			step := 125;
		END_IF;
	END_IF;

125: (* File Seek - Dateigroesse bestimmen *)
	seek_mode := UINT#2;  (* Positionierung relativ zum Dateiende *)
	seek_position := UDINT#0;
	command := BYTE#5; (* File Seek *)
	step := 130;

130: (* File Seek *)
	IF command = BYTE#0 THEN
		IF Error THEN
			step := 30000; (* Beenden *)
		ELSE
			step := 140;
		END_IF;
	END_IF;

140: (* File Tell - Position des Schreib/Lesezeiger auslesen *)
	command := BYTE#6; (* File Tell *)
	step := 150;

150: (* File Tell *)
	IF command = BYTE#0 THEN
		IF Error THEN
			step := 30000; (* Beenden *)
		ELSE
			FSD.FILE_SIZE := tell_position; (* aktuelle Dateigroesse *)
			file_position := tell_position;
			FSD.FILE_OPEN := TRUE;
			step := 200;
		END_IF;
	END_IF;

200: (* File Seek *)
	IF FSD.OFFSET > FSD.FILE_SIZE THEN (* prüfe auf gültige offset-vorgabe *)
		error_code := BYTE#255;
		step := 30000; (* Beenden *)
	ELSIF FSD.OFFSET <> file_position THEN
		command := BYTE#5; (* File-Seek *)
		seek_mode := UINT#0; (* Positionierung relativ zum Dateianfang *)
		seek_position := FSD.OFFSET;
		step := 210;
	ELSE
		step := 300;
	END_IF;

210: (* File Seek *)
	IF command = BYTE#0 THEN
		file_position := seek_position;
		IF Error THEN
			step := 30000; (* Beenden *)
		ELSE
			step := 300;
		END_IF;
	END_IF;

300:
	IF FSD.MODE = BYTE#1 THEN
		step := 400; (* Read *)
	ELSE
		step := 500; (* Write *)
	END_IF;

400: (* File Read *)
	IF UINT_TO_UDINT(PT.SIZE) > buf_size THEN (* Leselänge auf Buffergroesse begrenzen *)
		read_max_length := buf_size;
	ELSE
		read_max_length := UINT_TO_UDINT(PT.SIZE);
	END_IF;

	(* Leselänge an Dateilänge anpassen *)
	IF file_position + read_max_length > FSD.FILE_SIZE THEN
		read_max_length := FSD.FILE_SIZE - file_position;
	END_IF;

	IF read_max_length > UDINT#0 THEN
		command := BYTE#3; (* File_Read *)
		step := INT#410;
	ELSE
		PT.SIZE := UINT#0;
		step := 30000; (* Beenden *)
	END_IF;

410: (* File Read *) 
	IF command = BYTE#0 THEN
		PT.SIZE := UDINT_TO_UINT(length_read);
		IF NOT Error THEN
			file_position := file_position + length_read; (* aktueller File_Position korrigieren *)
			FSD.OFFSET := file_position;
		END_IF;
		step := 30000; (* Beenden *)
	END_IF;

500: (* File Write *)
	IF UINT_TO_UDINT(PT.SIZE) > buf_size THEN (* Schreiblänge auf Buffergroesse begrenzen *)
		write_length := buf_size;
	ELSE
		write_length := UINT_TO_UDINT(PT.SIZE);
	END_IF;

	IF write_length > UDINT#0 THEN
		command := BYTE#4; (* File_Write *)
		step := INT#510;
	ELSE
		step := 30000; (* Beenden *)
	END_IF;

510:
	IF command = BYTE#0 THEN
		IF NOT Error THEN
			file_position := file_position + length_written; (* aktueller File_Position korrigieren *)
			FSD.OFFSET := file_position;
			IF file_position > FSD.FILE_SIZE THEN (* Datei ist groesser geworden *)
				FSD.FILE_SIZE := file_position;
			END_IF;
		END_IF;
		step := 30000; (* Beenden *)
	END_IF;

(* --------------------------------------------- *)

30000: (* Befehl fertig *)
	FSD.MODE := BYTE#0;
	FSD.ERROR := error_code;
	step := 0;
	(* ---------------------- Debug-Message ----------------------------*)
	(*IF _debug_enable THEN
		LOG_CL.NEW_MSG := 'File_Stop: File ~1, error ~7, code ~8';
		LOG_CL.PRINTF[1]  := used_filename;
		LOG_CL.PRINTF[7]  := INT_TO_STRING(BOOL_TO_INT(error),'%d');
		LOG_CL.PRINTF[8]  := BYTE_TO_STRING(error_code,'%u');
		LOG_MSG();
	END_IF;*)
	(* -----------------------------------------------------------------*)

32000:
	close_time := T#0s; (* Timer stoppen *)
	IF handle > UINT#0 THEN
		command := BYTE#2; (* File_Close ausführen *)
	END_IF;
	step := 32100;

32100:
	IF command = BYTE#0 THEN (* File Close beendet *)
		(* Filedaten ablöschen *)
		FSD.FILE_OPEN := FALSE;
		file_position := UDINT#0;
		FSD.FILE_SIZE := UDINT#0;
		FSD.OFFSET := UDINT#0;
		used_filename := '';
		handle := UINT#00;

		(* File_Name wurde fliegend geändert ? *)
		IF file_change THEN
			file_change := FALSE;
			step := 100;
		ELSE 
			step := 30000;
		END_IF;
	END_IF;

END_CASE;

(* ------------ File Open ------------- *)
FILE_OPEN.Execute := command = BYTE#1;
FILE_OPEN.Name := FSD.FILENAME;
FILE_OPEN();
open_handle := FILE_OPEN.Handle;

IF command = BYTE#1 THEN
	IF FILE_OPEN.Done THEN
		error := FILE_OPEN.Error;
		command := BYTE#0;
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_OPEN.ErrorID));
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Open: File ~1, error ~7, code ~8';
			LOG_CL.PRINTF[1] := FSD.FILENAME;
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ----------- File Close ------------- *)
FILE_CLOSE.Execute := command = BYTE#2;
FILE_CLOSE.Handle := Handle;
FILE_CLOSE();

IF command = BYTE#2 THEN
	IF FILE_CLOSE.Done THEN
		error := FILE_CLOSE.Error;
		command := BYTE#0;
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_CLOSE.ErrorID + UINT#10)); (* Errorcode basis verschieben *)
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Close: File ~1, error ~7, code ~8';
			LOG_CL.PRINTF[1] := used_filename;
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ------------ File Read ------------- *)
FILE_READ.Execute := command = BYTE#3;
FILE_READ.Handle := handle;
FILE_READ.MaxLength := read_max_length;
FILE_READ.Buffer := PT.BUFFER;
FILE_READ();
PT.BUFFER := FILE_READ.Buffer;

IF command = BYTE#3 THEN
	IF FILE_READ.Done THEN
		error := FILE_READ.Error;
		command := BYTE#0;
		length_read :=  FILE_READ.LengthRead;
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_READ.ErrorID + UINT#40)); (* Errorcode basis verschieben *)
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Read: File ~1, soll ~2,ist ~3, offset ~4 ,error ~7, code ~8';
			LOG_CL.PRINTF[1] := used_filename;
			LOG_CL.PRINTF[2] := UDINT_TO_STRING(read_max_length,'%u');
			LOG_CL.PRINTF[3] := UDINT_TO_STRING(length_read,'%u');
			LOG_CL.PRINTF[4] := UDINT_TO_STRING(FSD.OFFSET,'%u');
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ------------ File Write ------------- *)
FILE_WRITE.Execute   := command = BYTE#4;
FILE_WRITE.Handle    := handle;
FILE_WRITE.Length    := write_length ;
FILE_WRITE.Buffer    := PT.BUFFER;
FILE_WRITE();
PT.BUFFER := FILE_WRITE.Buffer;

IF command = BYTE#4 THEN
	IF FILE_WRITE.Done THEN
		error := FILE_WRITE.Error;
		command := BYTE#0;
		(*length_written := FILE_WRITE.LengthWritten; Originalcode !! *)
		length_written := write_length; (* Workaround für BUG *)
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_WRITE.ErrorID + UINT#70)); (* Errorcode basis verschieben *)
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Write: File ~1, soll ~2,ist ~3, offset ~4 ,error ~7, code ~8';
			LOG_CL.PRINTF[1] := used_filename;
			LOG_CL.PRINTF[2] := UDINT_TO_STRING(write_length,'%u');
			LOG_CL.PRINTF[3] := UDINT_TO_STRING(length_written,'%u');
			LOG_CL.PRINTF[4] := UDINT_TO_STRING(FSD.OFFSET,'%u');
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ------------ File Seek ------------- *)
FILE_SEEK.Execute  := command = BYTE#5;
FILE_SEEK.Handle   := handle;
FILE_SEEK.Mode     := seek_mode;
FILE_SEEK.Position := UDINT_TO_DINT(seek_position);
FILE_SEEK();

IF command = BYTE#5 THEN
	IF FILE_SEEK.Done THEN
		error := FILE_SEEK.Error;
		command := BYTE#0;
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_SEEK.ErrorID + UINT#100)); (* Errorcode basis verschieben *)
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Seek: File ~1, mode ~2,pos ~3 ,error ~7, code ~8';
			LOG_CL.PRINTF[1] := used_filename;
			LOG_CL.PRINTF[2] := UINT_TO_STRING(seek_mode,'%u');
			LOG_CL.PRINTF[3] := UDINT_TO_STRING(seek_position,'%u');
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ------------ File Tell ------------- *)
FILE_TELL.Execute := command = BYTE#6;
FILE_TELL.Handle := handle;
FILE_TELL();

IF command = BYTE#6 THEN
	IF FILE_TELL.Done THEN
		error := FILE_TELL.Error;
		command := BYTE#0;
		tell_position := DINT_TO_UDINT(FILE_TELL.Position);
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_TELL.ErrorID + UINT#130)); (* Errorcode basis verschieben *)
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Tell: File ~1, pos ~3 ,error ~7, code ~8';
			LOG_CL.PRINTF[1] := used_filename;
			LOG_CL.PRINTF[3] := UDINT_TO_STRING(tell_position,'%u');
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ------------ File Remove ------------- *)
FILE_REMOVE.Execute := command = BYTE#7;
FILE_REMOVE.Name := FSD.FILENAME;
FILE_REMOVE();

IF command = BYTE#7 THEN
	IF FILE_REMOVE.Done THEN
		error := FILE_REMOVE.Error;
		command := BYTE#0;
		error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_REMOVE.ErrorID + UINT#140)); (* Errorcode basis verschieben *)
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'Remove: File ~1, error ~7, code ~8';
			LOG_CL.PRINTF[1] := used_filename;
			LOG_CL.PRINTF[7] := INT_TO_STRING(BOOL_TO_INT(error),'%d');
			LOG_CL.PRINTF[8] := BYTE_TO_STRING(error_code,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)
	END_IF;
END_IF;

(* ---------------------- Debug-Message ----------------------------*)
(*IF _debug_enable THEN
	IF step_last <> step THEN
		LOG_CL.NEW_MSG := 'Step: ~1';
		LOG_CL.PRINTF[1]  := INT_TO_STRING(step,'%d');
		LOG_MSG();
	END_IF;
	step_last := step;
END_IF;*)
(* -----------------------------------------------------------------*)

(* revision history
ks	23. sep. 2010	rev 1.0
	original version
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
