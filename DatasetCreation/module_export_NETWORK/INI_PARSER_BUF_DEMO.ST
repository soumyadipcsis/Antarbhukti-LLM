(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DEMO
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM INI_PARSER_BUF_DEMO

(*Group:log*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:log*)


(*Group:INI_PARAMETER*)


VAR
	SMTP_SERVER :	STRING;
	SMTP_FROM :	STRING;
	STATION_NAME :	STRING;
	STATION_IP :	STRING;
END_VAR


(*Group:lokal*)


VAR
	IPB :	INI_PARSER_BUF;
	FS :	FILE_SERVER;
	FSD :	oscat_FILE_SERVER_DATA;
	PT :	oscat_NETWORK_BUFFER;
	section :	INT;
	key :	oscat_STRING250;
	value :	oscat_STRING250;
	str :	oscat_STRING250;
	step :	INT;
	result :	BYTE;
	offset :	UDINT;
	run :	BYTE;
	done :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: INI_PARSER_BUF_DEMO
IEC_LANGUAGE: ST
*)
(* Demo-Programm: INI-Datei mittels Enumeration auswerten *)

(* ----- den nachfolgenden Textblock als datei "config.ini" auf der sps ablegen --- 
# Demo - Initialisierungsdatei

[Station]
NAME=Test_Station_1
IP=192.168.178.1

[SMTP]
SERVER=test.server.de
FROM=test1@gmx.net
---------------------------------------------------------------------------------*)

CASE step OF

00:	IF NOT done THEN
	 	(* File_Daten einrichten  *)
		FSD.FILENAME := 'config.ini'; (* Dateiname *)
		FSD.MODE := BYTE#1; (* vorhandene Datei zum lesen öffnen *)
		FSD.OFFSET := UDINT#0; (* Start bei Dateianfang *)
		FSD.AUTO_CLOSE := T#0s; (* kein Auto-Close verwenden *)
		PT.SIZE := UINT#65535; (* maximale länge einlesen *)
		step := 10;	
	END_IF;

10:	IF FSD.MODE = BYTE#0 THEN (* Datei geöffnet ? *)
		offset := UDINT#0; (* Start Offset vorgeben *)
		str := '';
		run := BYTE#3; (* key suchen *)
		step := 50;	
	END_IF;

50:	IF run = BYTE#0 THEN
		(* ---------------------- Debug-Message ----------------------------*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := '/key >~1< /value >~2< /offset ~3 /Run ~4 /Result ~5';
			LOG_CL.PRINTF[1] := key;
			LOG_CL.PRINTF[2] := value;
			LOG_CL.PRINTF[3] := UDINT_TO_STRING(offset,'%u');
			LOG_CL.PRINTF[4] := BYTE_TO_STRING(run,'%u');
			LOG_CL.PRINTF[5] := BYTE_TO_STRING(result,'%u');
			LOG_MSG();
		END_IF;*)
		(* -----------------------------------------------------------------*)

		run := BYTE#3; (* vorbelegung -> naechsten key suchen *)

		IF result = BYTE#1 THEN (* neue Sektion gefunden *)
			IF EQ_STRING(key,'Station') THEN
				section := 1;
			ELSIF EQ_STRING(key,'SMTP') THEN
				section := 2;

			(* hier können weitere Section hinzugefügt werden *) 

			ELSE
				section := 0; (* unbekannte sektion gefunden -> ignorieren *)
			END_IF;

		ELSIF result = BYTE#2 AND section > 0 THEN (* Key in einer bekannten sektion gefunden *)

			CASE section OF

			1:  (* Section: Station *)
				IF EQ_STRING(key,'NAME') THEN
					STATION_NAME := value; (* Name *)
				ELSIF EQ_STRING(key,'IP') THEN
					STATION_IP := value; (* IP-Adresse *)
				END_IF;

			2:  (* Section: SMTP *)
				IF EQ_STRING(key,'SERVER') THEN
					SMTP_SERVER := value; (* SMTP Server *)
				ELSIF EQ_STRING(key,'FROM') THEN
					SMTP_FROM := value; (* SMTP Absender *)
				END_IF;

			(* hier können weitere Sectionsauswertungen hinzugefügt werden *) 

			END_CASE;

		ELSIF result = BYTE#10 THEN (* nichts mehr gefunden *)
			run := BYTE#0; (* keine weitere INI Auswertung erwünscht *)
			FSD.MODE := BYTE#5; (* Datei schliessen *)
			step := 80;
		END_IF;
	END_IF;

80:	IF FSD.MODE = BYTE#0 THEN (* Datei geschlossen ? *)
		done := TRUE;
		step := 0;
	END_IF;

END_CASE;

(* INI PARAMETER BUF *)
IPB(STR:=str,RUN:=run,OFFSET:=offset,KEY:=key,VALUE:=value,PT:=PT);
str:=IPB.STR;
run:=IPB.RUN;
offset:=IPB.OFFSET;
key:=IPB.KEY;
value:=IPB.VALUE;
PT:=IPB.PT;
result:=IPB.RESULT;

(* FILE_SERVER *)
FS(FSD:=FSD,PT:=PT);
FSD:=FS.FSD;
PT:=FS.PT;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
