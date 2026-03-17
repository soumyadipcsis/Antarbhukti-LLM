(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.1		20. jun. 2009
programmer 		ks
tested by		ks

SYSLOG versendet Meldungen auf Basis des SYSLOG-Standards
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SYS_LOG

(*Group:debug*)


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


VAR
	(*<_debug_enable :	BOOL := TRUE;>*)
	(*<LOG_MSG :	LOG_MSG;>*)
END_VAR


(*Group:Default*)


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
	R_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR_INPUT
	ACTIVATE :	BOOL;
	LDT :	UDINT;(*Lokal DateTime (TYPE DT)*)
	SERVER_IP4 :	DWORD;
	PORT :	WORD;
	FACILITY :	BYTE;
	SEVERITY :	BYTE;
	TAG :	oscat_STRING32;
	HOSTNAME :	STRING;
	MESSAGE :	oscat_STRING250;
	OPTION :	BYTE;
END_VAR


VAR_OUTPUT
	DONE_P :	BOOL;
	ERROR :	DWORD;
END_VAR


VAR
	IP_FIFO :	IP_FIFO;
	_STRING_TO_BUFFER :	_STRING_TO_BUFFER_NW;
	DT_TO_STRF :	DT_TO_STRF;
	ip_state :	BYTE;
	ip_id :	BYTE;
	activate_last :	BOOL;
	state :	INT;
	s1 :	oscat_STRING20;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SYS_LOG
IEC_LANGUAGE: ST
*)

CASE state OF 
00: (* auf positive Flanke SET warten *)
  IF ACTIVATE AND NOT activate_last THEN
    state := 10;
    ERROR := DWORD#0;
    ip_state := BYTE#1; (* Anmelden *)
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SYS_LOG: S00 START /IP_ID ~4';
      LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;
  DONE_P := FALSE;

10: (* Bei IP_Control anmelden und auf freigabe warten *)
  IF ip_state = BYTE#3 THEN
 
    (*-----------------------------------------------------------*) 
    (* Sendedaten aufbereiten                                    *)
    (*-----------------------------------------------------------*) 
    i := 0;

    IF (OPTION AND BYTE#0000_0001) = BYTE#00 THEN (* Option: no priority Code *)
      (*-----------------------------------------------------------*) 
      (* Priority:  '<xx>' als dezimalwert                         *)
      (* BYTE: xxxx x...  = Facility                               *)
      (*       .... .xxx  = Level                                  *)
      (*-----------------------------------------------------------*) 
      s1:=REPLACE('<P>',BYTE_TO_STRING(SHL_BYTE(FACILITY,3) OR (SEVERITY AND BYTE#0000_0111),'%u'),1,2);
    ELSE
      s1 := '';
    END_IF;

    IF (OPTION AND BYTE#0000_0010) = BYTE#00 THEN (* Option: No Use Syslog RFC Header *)

      (* 'month day hh:mm:ss ' *)
      DT_TO_STRF(DTI:=LDT,MS:=0,FMT:='#E #W #N:#R:#T ',LANG:=1);
      s1 := CONCAT(s1,DT_TO_STRF.DT_TO_STRF);

      _STRING_TO_BUFFER(str:=s1,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
      S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

      i := i + LEN(s1);

      (* ' sourcename eintragen *)
      _STRING_TO_BUFFER(str:=HOSTNAME,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
      S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

      i := i + LEN(HOSTNAME);
      S_BUF.BUFFER[i] := BYTE#32; (* leerzeichen einfuegen *)
      i := i + 1;
    
      (* ' tag eintragen *)
      _STRING_TO_BUFFER(str:=TAG,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
      S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

      i := i + LEN(TAG);
      S_BUF.BUFFER[i] := BYTE#32; (* leerzeichen einfuegen *)
      i := i + 1;
    END_IF;

    (* ' message eintragen *)
    _STRING_TO_BUFFER(str:=MESSAGE,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
    S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

    i := i + LEN(MESSAGE);

    IF (OPTION AND BYTE#0000_0100) > BYTE#00 THEN (* Option: Add a CR & LF to end of message *)
      S_BUF.BUFFER[i] := BYTE#13; (* Carriage Return einfuegen *)
      i := i + 1;
      S_BUF.BUFFER[i] := BYTE#10; (* Linefeed einfuegen *)
      i := i + 1;
    END_IF;   

    state := 30;

    (* IP Datenverkehr einrichten *) 
    IF (OPTION AND BYTE#2#0000_1000) > BYTE#00 THEN (* Option: TCP Mode            *)
      IP_C.C_MODE := BYTE#0;              (* Mode: TCP/AKTIV                             *)
    ELSE
      IP_C.C_MODE := BYTE#1;              (* Mode: UDP/AKTIV                             *)
    END_IF;    

    IF PORT = WORD#0 THEN                 (* keine Portnummer vorgegeben ?                 *)
      IF IP_C.C_MODE = BYTE#0 THEN        (* Modus bestimmen  TCP oder UDP ?               *)
        IP_C.C_PORT := WORD#1468;         (* Standard Portnummer für Syslog over TCP       *)
	  ELSE
        IP_C.C_PORT := WORD#514;          (* Standard Portnummer für Syslog over UDP       *)
      END_IF;    
    ELSE
      IP_C.C_PORT := PORT;                (* uebergebene Portnummer eintragen              *)
	END_IF;

    IP_C.C_IP       := SERVER_IP4;        (* IP eintragen                                  *)
    IP_C.C_ENABLE   := TRUE;              (* Verbindungsaufbau freigeben                   *)
    IP_C.TIME_RESET := TRUE;              (* Zeitueberwachung rücksetzen                   *)
    IP_C.R_OBSERVE  := FALSE;             (* Datenempfang ueberwachen                      *)
    S_BUF.SIZE      := INT_TO_UINT(i);    (* Sendelänge eintragen                          *)
    R_BUF.SIZE      := UINT#0;            (* Empfangslänge rücksetzen                      *) 
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SYS_LOG: S20 SEND /IP_ID ~4';
      LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;

30:
  IF IP_C.ERROR <> DWORD#00 THEN
    ERROR := IP_C.ERROR;
    state := 0;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SYS_LOG: S30 ERROR ~1 IP_ID ~4';
      LOG_CL.PRINTF[1]  := DWORD_TO_STRING(ERROR,'%08X');
      LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)

  ELSIF S_BUF.SIZE = UINT#0 THEN (* warten bis alle daten gesendet sind *)
    DONE_P := TRUE;
    state := 0;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SYS_LOG: S30 OK /IP_ID ~4';
      LOG_CL.PRINTF[4]  := BYTE_TO_STRING(IP_ID,'%u');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;  

  IF state = 0 THEN  (* Verbindung freigeben *)
    ip_state := BYTE#4;
  END_IF;

END_CASE;

activate_last := ACTIVATE; (* letzten Status sichern zur Flankenerkennung *)

(* IP_FIFO *)
IP_FIFO(FIFO:=IP_C.FIFO,state:=IP_STATE,ID:=ip_id);
IP_C.FIFO := IP_FIFO.FIFO;
ip_state := IP_FIFO.STATE;
ip_id := IP_FIFO.ID;


(* revision history
ks	18. oct. 2008	rev 1.0
	original version

ks	20. jun. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
