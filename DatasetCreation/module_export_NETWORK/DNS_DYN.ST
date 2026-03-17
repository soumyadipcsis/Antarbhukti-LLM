(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)
version 1.2		02. dec. 2009
programmer 		ks
tested by		ks

YAHOO_WEATHER lädt vom Yahoo-Webserver einen Wetter RSS-Feed und analysiert die Daten und legt diese in einem Array ab

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DNS_DYN

(*Group:Default*)


VAR_INPUT
	ENABLE :	BOOL;
	UPDATE :	BOOL;
	T_UPDATE :	TIME := T#1h;
	MODE :	BYTE;
	HOSTNAME :	oscat_STRING30;
	USERNAME :	oscat_STRING20;
	PASSWORD :	oscat_STRING20;
	IP4 :	DWORD;
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
END_VAR


VAR
	STRING_TO_URL :	STRING_TO_URL;
	DNS_CLIENT :	DNS_CLIENT;
	HTTP_GET :	HTTP_GET;
	BASE64_ENCODE_STR :	BASE64_ENCODE_STR;
	URL_DATA :	oscat_url;
	update_last :	BOOL;
	state :	INT;
	base64_done :	BOOL;
	s1 :	oscat_STRING144;
	s2 :	oscat_STRING192;
	w :	TON;
	delimiter2b :	oscat_STRING2;
	BUFFER_TO_STRING :	BUFFER_TO_STRING_NW;
	IP4_TO_STRING :	IP4_TO_STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: DNS_DYN
IEC_LANGUAGE: ST
*)
CASE state OF

00:	IF ENABLE AND ((UPDATE AND NOT update_last) OR w.Q) THEN
		state := 20;
		DONE := FALSE;
		BUSY := TRUE;
		ERROR_C := DWORD#0;
		ERROR_T := BYTE#0;

		IF MODE = BYTE#0 THEN (* dyndns.org *)
			s2 := CONCAT('http://members.dyndns.org/nic/update?hostname=',HOSTNAME);
		ELSE (* selfhost.de *)
			s2 := 'http://carol.selfhost.de/nic/update?hostname=1';
		END_IF;
		IF IP4 > DWORD#0 THEN (* parametrierte IP verwenden *)

			IP4_TO_STRING(IP4:=IP4);
			s1 := CONCAT('&myip=',IP4_TO_STRING.IP4_TO_STRING);
			s2 := CONCAT(s2,s1);
		END_IF;

		STRING_TO_URL(STR:=s2,DEFAULT_PROTOCOL:='',DEFAULT_PATH:='');
		URL_DATA:=STRING_TO_URL.STRING_TO_URL;

		s1 := CONCAT(USERNAME,':');
		s1 := CONCAT(s1,PASSWORD); (* BASE64 Encode Text *)
	END_IF;

20:	IF DNS_CLIENT.DONE THEN (* DNS_CLIENT *)
			state := 40;
	ELSIF (DNS_CLIENT.ERROR > DWORD#00) THEN (* Fehlerbehandlung *)
		ERROR_C := DNS_CLIENT.ERROR;
		ERROR_T := BYTE#01;
		BUSY := FALSE;
		state := 0;
	END_IF;

40: IF base64_done THEN (* BASE64 Encode beendet ? *)
		s1 := CONCAT('Authorization: Basic ',s2);
		(* workaround für pcworx -> kein $0D$0A als Stringkonstante möglich *)
		delimiter2b := CONCAT(BYTE_TO_STRING(BYTE#16#0D,'%c'),BYTE_TO_STRING(BYTE#16#0A,'%c'));
		s1 := CONCAT(s1,delimiter2b);
		s1 := CONCAT(s1,'User-Agent: x');
		s1 := CONCAT(s1,delimiter2b);
		URL_DATA.HEADER := s1;
		state := 60;
	END_IF;

60:	IF HTTP_GET.DONE THEN
		state := 0;
		BUSY := FALSE;
		DONE := TRUE;

		(* !! Codes !!
		Successful Updates: 		good , nchg
		Update Syntax Errors:		badsys , badagent
		Account-Related Errors:		badauth , !donator
		Hostname-Related Errors:	notfqdn , nohost , !yours , numhost , abuse
		Server Error Conditions:	dnserr , 911
		*)
		BUFFER_TO_STRING(PT:=R_BUF.BUFFER,SIZE:=UINT#4096,START:=HTTP_GET.BODY_START + UINT#3,STOP:=HTTP_GET.BODY_STOP - UINT#7);
		R_BUF.BUFFER:=BUFFER_TO_STRING.PT;
		s2:=BUFFER_TO_STRING.BUFFER_TO_STRING;

		IF FIND(s2,'good') = 0 THEN
			IF FIND(s2,'nochg') = 0 THEN
				ERROR_C := DWORD#1;
				ERROR_T := BYTE#03;
				DONE := FALSE;
			END_IF;
		END_IF;
	ELSIF (HTTP_GET.ERROR > DWORD#00) THEN (* Fehlerbehandlung *)
		ERROR_C := HTTP_GET.ERROR;
		ERROR_T := BYTE#02;
		BUSY := FALSE;
		state := 0;
	END_IF;

END_CASE;

DNS_CLIENT(IP_C:=IP_C,S_BUF:=S_BUF,R_BUF:=R_BUF,ACTIVATE:=state=20,DOMAIN:=URL_DATA.DOMAIN,IP4_DNS:=DWORD#0);
IP_C:=DNS_CLIENT.IP_C;
S_BUF:=DNS_CLIENT.S_BUF;
R_BUF:=DNS_CLIENT.R_BUF;

HTTP_GET(URL_DATA:=URL_DATA,IP_C:=IP_C,S_BUF:=S_BUF,R_BUF:=R_BUF,IP4:=DNS_CLIENT.IP4,GET:=state=60,MODE:=BYTE#2,UNLOCK_BUF:=state<>60); (* HTTP_GET *)
URL_DATA:=HTTP_GET.URL_DATA;
IP_C:=HTTP_GET.IP_C;
S_BUF:=HTTP_GET.S_BUF;
R_BUF:=HTTP_GET.R_BUF;

BASE64_ENCODE_STR(RUN:=state=40,STR1:=s1,STR2:=s2);
base64_done:=BASE64_ENCODE_STR.DONE;
s1:=BASE64_ENCODE_STR.STR1;
s2:=BASE64_ENCODE_STR.STR2;

IF T_UPDATE > T#0ms THEN w(IN:=state=0, PT:=T_UPDATE); END_IF;
update_last := UPDATE;

(* revision history
ks	01. jan. 2010	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
