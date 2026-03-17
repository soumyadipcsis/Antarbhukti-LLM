(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.1	28. dec. 2009
programmer 	ks
tested by	ks

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK GET_WAN_IP

(*Group:in_out*)


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR_INPUT
	ACTIVATE :	BOOL;
END_VAR


VAR_OUTPUT
	WAN_IP4 :	DWORD;
	DONE :	BOOL;
	NEW_IP4 :	BOOL;
	ERROR_C :	DWORD;
	ERROR_T :	BYTE;
END_VAR


(*Group:var*)


VAR
	CHR_TO_STRING :	CHR_TO_STRING;
	IP4_DECODE :	IP4_DECODE;
	URL_DATA :	oscat_url;
	DNS_CLIENT :	DNS_CLIENT;
	STRING_TO_URL :	STRING_TO_URL;
	HTTP_GET :	HTTP_GET;
	activate_last :	BOOL;
	wan_ip4_last :	DWORD;
	state :	INT;
	st_ip :	oscat_STRING120;
	i1 :	INT;
	p1 :	INT;
	p2 :	INT;
	p3 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)

CASE state OF

00:
  IF ACTIVATE AND NOT activate_last THEN
    state := 20;
	DONE := FALSE;
	ERROR_C := DWORD#0;
	ERROR_T := BYTE#0;
  END_IF;

20: (* URL for DNS UND HTTP-GET *)
  STRING_TO_URL.STR:='checkip.dyndns.com';
  STRING_TO_URL.DEFAULT_PROTOCOL:='';
  STRING_TO_URL.DEFAULT_PATH:='';
  STRING_TO_URL();
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
    state := 80;

  ELSIF (HTTP_GET.ERROR > DWORD#00) THEN
    (* Fehlerbehandlung *)
    ERROR_C := HTTP_GET.ERROR;
	ERROR_T := BYTE#02;
    state   := 100;
  END_IF;

80:
  (* Als Antwort wird folgende HTML Seite empfangen , hier muss die IP-Adresse herauskopiert werden *)
  (* <html><head><title>Current IP Check</title></head><body>Current IP Address: 85.127.217.33</body></html> *)
  st_ip := '';
  p1 := 0;
  FOR i1 := UINT_TO_INT(HTTP_GET.BODY_START) TO UINT_TO_INT(HTTP_GET.BODY_STOP) DO
		IF R_BUF.BUFFER[i1] = BYTE#58 THEN (* suche ':' *)
			p1 := i1 + 2;
			EXIT;
		END_IF;
  END_FOR;
		
	p3 := p1 + 15;
	IF p1 > 0 AND p3 < UINT_TO_INT(HTTP_GET.BODY_STOP) THEN
		FOR p2 := p1 TO p3 DO
			IF R_BUF.BUFFER[p2] <> BYTE#60 THEN (* suche '<' *)
				CHR_TO_STRING(C:=R_BUF.BUFFER[p2]);
				st_ip := CONCAT(st_ip,CHR_TO_STRING.CHR_TO_STRING);
			ELSE
				EXIT;
			END_IF;
		END_FOR;
	END_IF;
  
	IP4_DECODE(STR:=st_ip);
	WAN_IP4 := IP4_DECODE.IP4_DECODE;

  IF WAN_IP4 <> DWORD#0 THEN
    DONE  := TRUE;
	NEW_IP4 := WAN_IP4 <> wan_ip4_last;
	wan_ip4_last := WAN_IP4;
  ELSE
    ERROR_C := DWORD#01; (* keine gültige IP gefunden *)
	ERROR_T := BYTE#03;
  END_IF; 
  state := 100;

100:
  (* UNLOCK HTTP DATA *)
  IF (NOT HTTP_GET.DONE) THEN
    state := 0;
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

activate_last := ACTIVATE;

(* revision history
ks	03. mar 2009	rev 1.0
	original version

ks	28. dec 2009	rev 1.1
	new WAN_IP4 , NEW_IP4 

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
