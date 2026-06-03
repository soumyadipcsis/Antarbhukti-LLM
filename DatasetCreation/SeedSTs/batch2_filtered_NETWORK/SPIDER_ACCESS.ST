(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.1	12. apr. 2011
programmer 	ks
tested by	ks

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SPIDER_ACCESS

(*Group:in_out*)


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
	VALUE :	STRING;
	VAR_NAME :	oscat_STRING40;
END_VAR


VAR_INPUT
	MODE :	BYTE;
END_VAR


VAR_OUTPUT
	ERROR :	DWORD;
END_VAR


(*Group:var*)


VAR
	STATE :	INT;
	st_tmp :	oscat_STRING250;
	STRING_TO_URL :	STRING_TO_URL;
	URL_DATA :	oscat_url;
	HTTP_GET :	HTTP_GET;
	BUFFER_TO_STRING :	BUFFER_TO_STRING_NW;
	VALUE_LEN :	UINT;
	BODY_LEN :	UINT;
	MODE_SAVE :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)

CASE state OF
 
00: 
  IF MODE > BYTE#0 AND MODE < BYTE#3 THEN
    MODE_SAVE := MODE; (* Modus speichern *)

    (* wenn kein '.' in Name dann ist es eine globale variable *)
    IF FIND(VAR_NAME,'.') = 0 THEN
 	  st_tmp := CONCAT('%40GV.',VAR_NAME);
    ELSE
	  st_tmp := VAR_NAME;
    END_IF;

    IF MODE_SAVE = BYTE#2 THEN (* 2 = Write *)
      VALUE_LEN := INT_TO_UINT(LEN(VALUE));
      st_tmp := CONCAT(st_tmp,'+');
      st_tmp := CONCAT(st_tmp,VALUE);
      STRING_TO_URL.STR:= CONCAT('http://x/dir/cgi-bin/writeVal.exe?',st_tmp);
	ELSE
  	  STRING_TO_URL.STR:= CONCAT('http://x/dir/cgi-bin/readVal.exe?',st_tmp);
    END_IF;

    (* URL aufbereiten *)
    STRING_TO_URL();
    URL_DATA:=STRING_TO_URL.STRING_TO_URL;

    state := 60;
  END_IF;
60:
  IF HTTP_GET.DONE THEN
    IF MODE_SAVE = BYTE#2 THEN (* Write *)
      BODY_LEN := HTTP_GET.BODY_STOP - HTTP_GET.BODY_START + BOOL_TO_UINT(HTTP_GET.BODY_STOP > UINT#0);
      ERROR := BOOL_TO_DWORD(BODY_LEN <> VALUE_LEN);
    ELSE (* Read *)
		IF HTTP_GET.BODY_START > UINT#0 THEN
            BUFFER_TO_STRING(SIZE:=R_BUF.SIZE,START:=HTTP_GET.BODY_START,STOP:=HTTP_GET.BODY_STOP,PT:=R_BUF.BUFFER);
            VALUE := BUFFER_TO_STRING.BUFFER_TO_STRING;
            R_BUF.BUFFER := BUFFER_TO_STRING.PT;
		ELSE
			VALUE := '';
		END_IF;
    END_IF;
    STATE   := 100;

  ELSIF (HTTP_GET.ERROR > DWORD#00) THEN
    ERROR := HTTP_GET.ERROR;
    STATE := 100;
  END_IF;

100:
  (* UNLOCK HTTP DATA *)
  IF HTTP_GET.DONE = FALSE THEN
    STATE := 0;
  END_IF; 

END_CASE;

(* HTTP_GET *)
HTTP_GET.IP_C        := IP_C;
HTTP_GET.S_BUF       := S_BUF;
HTTP_GET.R_BUF       := R_BUF;
HTTP_GET.IP4         := DWORD#00;
HTTP_GET.GET         := STATE=60;
HTTP_GET.MODE        := BYTE#0;
HTTP_GET.UNLOCK_BUF  := STATE=100; 
HTTP_GET.URL_DATA    := URL_DATA;
HTTP_GET();
IP_C     := HTTP_GET.IP_C;
S_BUF    := HTTP_GET.S_BUF;
R_BUF    := HTTP_GET.R_BUF;
URL_DATA := HTTP_GET.URL_DATA;

(* revision history
ks	18. mar. 2009	rev 1.0
	original version

ks	12. apr. 2011	rev 1.1
	fehlerkorrektur bei buffer_to_string
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
