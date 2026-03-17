(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: WEATHER
*)
(*@KEY@:DESCRIPTION*)
version 1.3		05. jan 2012
programmer 		ks
tested by		ks

WORLD_WEATHER lädt von worldweather.com eine Wetter csv-datei und analysiert die Daten und legt diese in einem Array ab
Die Wetterdaten werden für 5 tage aufbereitet

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK WORLD_WEATHER

(*Group:in_out*)


VAR_INPUT
	ACTIVATE :	BOOL;
	LATITUDE :	REAL;
	LONGITUDE :	REAL;
	KEY :	oscat_STRING30;
END_VAR


VAR_OUTPUT
	BUSY :	BOOL;
	DONE :	BOOL;
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	WW :	oscat_WORLD_WEATHER_DATA;
END_VAR


(*Group:var*)


VAR
	CHK_REAL :	CHK_REAL;
	REAL_TO_STRF :	REAL_TO_STRF;
	URL_DATA :	oscat_url;
	DNS_CLIENT :	DNS_CLIENT;
	HTTP_GET :	HTTP_GET;
	CPB :	CSV_PARSER_BUF;
	STRING_TO_URL :	STRING_TO_URL;
	FLOAT_TO_REAL :	FLOAT_TO_REAL;
	last_state :	BOOL;
	value_int :	INT;
	value_real :	REAL;
	v_real :	REAL;
	state :	INT;
	url_str :	oscat_STRING250;
	offset :	UDINT;
	size :	INT;
	sep :	BYTE;
	cnt :	INT;
	day :	INT;
	idx :	INT;
	run :	BYTE;
	result :	BYTE;
	value :	oscat_STRING250;
	DEC_TO_INT :	DEC_TO_INT;
	pos :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: WORLD_WEATHER
IEC_LANGUAGE: ST
*)
CASE state OF

00:
	IF ACTIVATE AND NOT last_state THEN
		state := 20;
		DONE := FALSE;
		BUSY := TRUE;
		ERROR_C := DWORD#0;
		ERROR_T := BYTE#0;
	END_IF;

20: (* URL for DNS UND HTTP-GET *)
	(* Example: http://free.worldweatheronline.com/feed/weather.ashx?q=48.21,16.37&format=csv&num_of_days=5&key=xxxxxxxxxxxxxxxxxxxxxx *)

	REAL_TO_STRF(IN:=LATITUDE,N:=6,D:='.');
	url_str := CONCAT('http://free.worldweatheronline.com/feed/weather.ashx?q=',REAL_TO_STRF.REAL_TO_STRF);
	url_str := CONCAT(url_str,',');
	REAL_TO_STRF(IN:=LONGITUDE,N:=6,D:='.');
	url_str := CONCAT(url_str,REAL_TO_STRF.REAL_TO_STRF);
	url_str := CONCAT(url_str,'&format=csv&num_of_days=5&key=');
	url_str := CONCAT(url_str,key);

	STRING_TO_URL(STR:=url_str, DEFAULT_PROTOCOL:='', DEFAULT_PATH:='' );
  	URL_DATA:=STRING_TO_URL.STRING_TO_URL;

	state := 40;

40:
	IF DNS_CLIENT.DONE THEN
		state := 60;
	ELSIF (DNS_CLIENT.ERROR > DWORD#00) THEN
		(* Fehlerbehandlung *)
		ERROR_C := DNS_CLIENT.ERROR;
		ERROR_T := BYTE#01;
		state   := 100;
	END_IF;

60:
	IF HTTP_GET.DONE THEN
		sep := BYTE#0;
		idx := 0;
		day := 0;
		cnt := 0;
		OFFSET := UINT_TO_UDINT(HTTP_GET.BODY_START); (* Start Offset vorgeben *)
		size := UINT_TO_INT(HTTP_GET.BODY_STOP); (* End Position *)
		run := BYTE#1; (* Element suchen *)
		state := 80;

	ELSIF (HTTP_GET.ERROR > DWORD#00) THEN
		(* Fehlerbehandlung *)
		ERROR_C := HTTP_GET.ERROR;
		ERROR_T := BYTE#02;
		state := 100;
	END_IF;

80:	IF run = BYTE#0 THEN (* kein Befehl mehr aktiv ? *)
		run := BYTE#1; (*  nächstes Element suchen  *)
		IF result = BYTE#1 OR result = BYTE#2 THEN
			value_int := 0;
			value_real := 0.0;
			(* automatische konvertierung in real und int ausführen *)
			IF LEN(value) <= 20 THEN
      			FLOAT_TO_REAL(FLT:=value);
				v_real := FLOAT_TO_REAL.FLOAT_TO_REAL;
				CHK_REAL(X := v_real); (* !!! prüft auf gültigen REAL Wert, ansonsten stürzt Twincat ab !!!!  *)
				IF CHK_REAL.CHK_REAL = BYTE#0 THEN
					value_real := v_real;
					value_int := REAL_TO_INT(value_real);
				END_IF;
			END_IF;
			cnt := cnt + 1;
			IF cnt >=8 AND cnt <= 87 THEN
				IF cnt > 22 THEN
					CASE idx OF
					00:	WW.DAY[day].DATE_OF_DAY := value;
					01:	WW.DAY[day].TEMP_MAX_C := value_int;
					02:	WW.DAY[day].TEMP_MAX_F := value_int;
					03:	WW.DAY[day].TEMP_MIN_C := value_int;
					04:	WW.DAY[day].TEMP_MIN_F := value_int;
					05:	WW.DAY[day].WIND_SPEED_MILES := value_int;
					06:	WW.DAY[day].WIND_SPEED_KMPH := value_int;
					07:	WW.DAY[day].WIND_DIR_DEGREE := value_int;
					08:	WW.DAY[day].WIND_DIR16POINT := value;
					09:	WW.DAY[day].WEATHER_CODE := value_int;
					10:	pos := FIND(value, '/wsymbol_');
                        IF pos > 0 AND LEN(value) > pos + 13 THEN
                            DEC_TO_INT(DEC:=MID(value,4,pos + 9));
                            WW.DAY[day].WEATHER_ICON := DEC_TO_INT.DEC_TO_INT;
                        ELSE
       						WW.DAY[day].WEATHER_ICON := 0;
                        END_IF;
					11:	WW.DAY[day].WEATHER_DESC := value;
					12:	WW.DAY[day].PRECIPMM := value_real;
					END_CASE;
					idx := idx + 1;
					IF idx > 12 THEN
						idx := 0;
						day := day + 1;
					END_IF;
				ELSE
					CASE cnt OF
					08:	sep := BYTE#44; (* ab jetzt mit Trennzeichen arbeiten, *)
					09:	WW.CUR.OBSERVATION_TIME := value;
					10:	WW.CUR.TEMP_C := value_int;
					11:	WW.CUR.WEATHER_CODE := value_int;
					12:	pos := FIND(value, '/wsymbol_');
                        IF pos > 0 AND LEN(value) > pos + 13 THEN
                            DEC_TO_INT(DEC:=MID(value,4,pos + 9));
                            WW.CUR.WEATHER_ICON := DEC_TO_INT.DEC_TO_INT;
                        ELSE
       						WW.CUR.WEATHER_ICON := 0;
                        END_IF;
					13:	WW.CUR.WEATHER_DESC := value;
					14:	WW.CUR.WIND_SPEED_MILES := value_int;
					15:	WW.CUR.WIND_SPEED_KMPH := value_int;
					16:	WW.CUR.WIND_DIR_DEGREE := value_int;
					17:	WW.CUR.WIND_DIR16POINT := value;
					18:	WW.CUR.PRECIPMM := value_real;
					19:	WW.CUR.HUMIDITY := value_int;
					20:	WW.CUR.VISIBILITY := value_int;
					21:	WW.CUR.PRESSURE := value_int;
					22:	WW.CUR.CLOUDOVER := value_int;
					END_CASE;
				END_IF;
			END_IF;
		ELSIF result = BYTE#10 THEN (* nichts mehr gefunden *)
			DONE  := TRUE;
			run := BYTE#0; (* Auswertung beenden *)
			state := 100;
		END_IF;
	END_IF;

100:
	(* UNLOCK HTTP DATA *)
	IF (NOT HTTP_GET.DONE) THEN
		state := 0;
		BUSY := FALSE;
		DONE := ERROR_T = BYTE#0;
	END_IF;

END_CASE;

(* ---------------- DNS --------------- *)
DNS_CLIENT.IP_C     := IP_C;
DNS_CLIENT.S_BUF    := S_BUF;
DNS_CLIENT.R_BUF    := R_BUF;
DNS_CLIENT.DOMAIN   := URL_DATA.DOMAIN;
DNS_CLIENT.IP4_DNS  := DWORD#00;
DNS_CLIENT.ACTIVATE := state=40; (* DNS Start *)
DNS_CLIENT();
IP_C  := DNS_CLIENT.IP_C;
S_BUF := DNS_CLIENT.S_BUF;
R_BUF := DNS_CLIENT.R_BUF;

(* nicht oder nicht direkt verwendete Parameter *)
(* DWORD :=DNS_CLIENT.IP4;
   BOOL  :=DNS_CLIENT.DONE;
   BYTE  :=DNS_CLIENT.ERROR; *)
(* -------------------------------------*)

(* ------------- HTTP_GET --------------- *)

HTTP_GET.IP_C        := IP_C;
HTTP_GET.S_BUF       := S_BUF;
HTTP_GET.R_BUF       := R_BUF;
HTTP_GET.IP4         := DNS_CLIENT.IP4;
HTTP_GET.GET         := state=60;
HTTP_GET.MODE        := BYTE#2; (* HTTP 1.1 mit persistenter Verbindung *)  
HTTP_GET.UNLOCK_BUF  := state=100; 
HTTP_GET.URL_DATA    := URL_DATA;
HTTP_GET();
IP_C     := HTTP_GET.IP_C;
S_BUF    := HTTP_GET.S_BUF;
R_BUF    := HTTP_GET.R_BUF;
URL_DATA := HTTP_GET.URL_DATA;

(* nicht oder nicht direkt verwendete Parameter *)
(*STRING := HTTP_GET.HTTP_STATUS;
  UINT :=HTTP_GET.HEADER_START;
  UINT :=HTTP_GET.HEADER_STOP;
  UINT :=HTTP_GET.BODY_START;
  UINT :=HTTP_GET.BODY_STOP;
  BOOL :=HTTP_GET.DONE;
  BYTE :=HTTP_GET.ERROR;
*)
(* -------------------------------------*)

CPB(SEP:=sep,RUN:=run,OFFSET:=offset,VALUE:=value,PT:=R_BUF); (* CSV PARAMETER BUF *)
run:=CPB.RUN;
offset:=CPB.OFFSET;
value:=CPB.VALUE;
R_BUF:=CPB.PT;
result:=CPB.RESULT;

last_state := ACTIVATE;

(* revision history
ks	01.oct. 2010	rev 1.0
	original version

ks	01.feb. 2011	rev 1.1
	rücksetzen von cnt 

ks	07.apr. 2011	rev 1.2
	neue Domain "free.worldweatheronline.com" (Ab 30.04.2011 notwendig)

ks	05.jan. 2012	rev 1.3
	neues datenelement "icon" integriert, REAL_TO_STRF parameter D
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
