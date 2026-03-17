(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 	1.1	07.oct. 2010
programmer 	ks
tested by	ks

IP2GEO ermittelt die aktuelle WAN-IP und die dazugehörigen geographischen Infos

zusatzinfos: http://www.worldtimezone.com/time/wtzresult.php?CiID=10182&forma=

example:

http://ipinfodb.com/ip_query.php?timezone=true&IP=

<?xml version="1.0" encoding="UTF-8" ?> 
- <Response>
  <Ip>85.127.218.109</Ip> 
  <Status>OK</Status> 
  <CountryCode>AT</CountryCode> 
  <CountryName>Austria</CountryName> 
  <RegionCode>09</RegionCode> 
  <RegionName>Wien</RegionName> 
  <City>Vienna</City> 
  <ZipPostalCode /> 
  <Latitude>48.2</Latitude> 
  <Longitude>16.3667</Longitude> 
  <TimezoneName>Europe/Vienna</TimezoneName> 
  <Gmtoffset>7200</Gmtoffset> 
  <Isdst>1</Isdst> 
  </Response>

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IP2GEO

(*Group:in_out*)


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	GEO :	oscat_IP2GEO_DATA;
END_VAR


VAR_INPUT
	IP :	DWORD;
	ACTIVATE :	BOOL;
END_VAR


VAR_OUTPUT
	BUSY :	BOOL;
	DONE :	BOOL;
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


(*Group:var*)


VAR
	CTRL :	oscat_XML_CONTROL;
	XML_READER :	XML_READER;
	URL_DATA :	oscat_url;
	DNS_CLIENT :	DNS_CLIENT;
	STRING_TO_URL :	STRING_TO_URL;
	HTTP_GET :	HTTP_GET;
	FLOAT_TO_REAL :	FLOAT_TO_REAL;
	last_state :	BOOL;
	value_int :	INT;
	value_real :	REAL;
	v_real :	REAL;
	state :	INT;
	IP4_TO_STRING :	IP4_TO_STRING;
	IP4_DECODE :	IP4_DECODE;
	CHK_REAL :	CHK_REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: IP2GEO
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
  (* Example: http://ipinfodb.com/ip_query.php?timezone=true&IP=10.10.10.10 *)
  STRING_TO_URL.STR:='http://ipinfodb.com/ip_query.php?timezone=true&IP=';
  STRING_TO_URL.DEFAULT_PROTOCOL:='';
  STRING_TO_URL.DEFAULT_PATH:='';
  STRING_TO_URL();
  URL_DATA:=STRING_TO_URL.STRING_TO_URL;

  IF IP > DWORD#0 THEN
    IP4_TO_STRING(IP4:=IP);
    URL_DATA.QUERY := CONCAT(URL_DATA.QUERY,IP4_TO_STRING.IP4_TO_STRING);
  END_IF;

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
    state := 80;
    CTRL.START_POS := HTTP_GET.BODY_START;
    CTRL.STOP_POS  := HTTP_GET.BODY_STOP;
    CTRL.COMMAND   := WORD#2#10000000_00011000; (* ONLY TEXT AND ATTRIBUTE *)
	CTRL.WATCHDOG  := T#1ms;

  ELSIF (HTTP_GET.ERROR > DWORD#00) THEN
    (* Fehlerbehandlung *)
    ERROR_C := HTTP_GET.ERROR;
	  ERROR_T := BYTE#02;
    state   := 100;
  END_IF;

80:
  (* XML Daten seriell lesen *)
  XML_READER.CTRL := CTRL;
  XML_READER.BUF  := R_BUF.BUFFER;
  XML_READER();
  CTRL         := XML_READER.CTRL;
  R_BUF.BUFFER := XML_READER.BUF;

  IF CTRL.TYP < 98 THEN (* nur auswerten wenn kein Watchdog durchlauf *)
		(* automatische konvertierung in real und int ausführen *)
		value_int := 0;
		value_real := 0.0;
		IF LEN(CTRL.VALUE) <= 20 THEN
      		FLOAT_TO_REAL(FLT:=CTRL.VALUE);
			v_real :=FLOAT_TO_REAL.FLOAT_TO_REAL;
			CHK_REAL(X:= v_real); (* !!! prüft auf gültigen REAL Wert, ansonsten stürzt Twincat ab !!!!  *)
			IF CHK_REAL.CHK_REAL = BYTE#0 THEN
				value_real := v_real;
				value_int := REAL_TO_INT(value_real);
			END_IF;
		END_IF;

    CASE UINT_TO_INT(CTRL.COUNT) OF 

      07: IP4_DECODE(STR:=CTRL.VALUE);
          GEO.IP4 := IP4_DECODE.IP4_DECODE; (* IP-Adresse *)
	  10: GEO.STATE := EQ_STRING('OK',CTRL.VALUE); (* STATUS *)
	  13: GEO.COUNTRY_CODE := CTRL.VALUE; (* Country-Code *)
	  16: GEO.COUNTRY_NAME := CTRL.VALUE; (* Country-Name *)
	  19: GEO.REGION_CODE := CTRL.VALUE; (* Region-Code *)
	  22: GEO.REGION_NAME := CTRL.VALUE; (* Region-Name *)
	  25: GEO.CITY := CTRL.VALUE; (* City *)
	  31: GEO.GEO_LATITUDE := value_real; (* Latitude *)
	  34: GEO.GEO_LONGITUDE := value_real; (* Longitude *)
	  37: GEO.TIME_ZONE_NAME := CTRL.VALUE; (* TimeZone Name *)
	  40: GEO.GMT_OFFSET := value_int; (* GMT OFFSET in Minuten *)
	  43: GEO.IS_DST := value_int > 0; (* Sommerzeit aktiv *)
    END_CASE;

  ELSIF CTRL.TYP = 99 THEN (* EXIT - letztes Element gelesen *)
    DONE  := TRUE;
    state := 100;
  END_IF; 

100:
  (* UNLOCK HTTP DATA *)
  IF (NOT HTTP_GET.DONE) THEN
    state := 0;
    BUSY  := FALSE;
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

last_state := ACTIVATE;


(* revision history
ks	14. aug. 2009	rev 1.0
	original version

ks	07. oct. 2010	rev 1.1
	new url , ip2geo fields , REAL_CHECK
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
