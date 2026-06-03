(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.2		17. may. 2011
programmer 		ks
tested by		ks

SNTP_SERVER stellt Datum/Uhrzeit für andere (S)NTP_CLIENTS zur Verfügung.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SNTP_SERVER

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
	ENABLE :	BOOL;
	STRATUM :	BYTE := BYTE#1;
	UDT :	UDINT;
	XMS :	INT;
END_VAR


VAR
	IP_STATE :	BYTE;
	IP_ID :	BYTE;
	IP_FIFO :	IP_FIFO;
	i2 :	INT;
	i :	INT;
	TIMESTAMP_INT :	DWORD;(*Timestamp integer part*)
	TIMESTAMP_SEK :	DWORD;(*Timestamp fraction part (HIGH_WORD)*)
	TS_B :	BYTE;
	state :	INT;
	T_PLC_MS :	T_PLC_MS;(*Bausteininstanz T_PLC_MS*)
	tx :	UDINT;
	t :	TON;
END_VAR


(*@KEY@: WORKSHEET
NAME: SNTP_SERVER
IEC_LANGUAGE: ST
*)
(* Domain Name System (query) *)
T_PLC_MS();
tx := T_PLC_MS.T_PLC_MS;  (* read system time *)

CASE state OF 

00: (* Warten auf Freigabe *)
  IF ENABLE THEN
    state := 10;
    IP_STATE := BYTE#1; (* Anmelden *)
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SNTP_SERVER: S00 START';
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;

10: (* Bei IP_Control anmelden und auf freigabe warten *)
  IF IP_STATE = BYTE#3 THEN

    (* IP Datenverkehr einrichten *) 
    IP_C.C_PORT     := WORD#123; (* Portnummer eintragen                          *)
    IP_C.C_IP       := DWORD#00; (* IP eintragen                                  *)
    IP_C.C_MODE     := BYTE#5;   (* Mode: UDP+PASSIV+PORT                         *)
    IP_C.C_ENABLE   := TRUE;     (* Verbindungsaufbau freigeben                   *)
    IP_C.TIME_RESET := TRUE;     (* Zeitueberwachung rücksetzen                   *)
    IP_C.R_OBSERVE  := FALSE;    (* Datenempfang ueberwachen                      *)
    S_BUF.SIZE      := UINT#0;   (* Sendelänge eintragen                          *)
    R_BUF.SIZE      := UINT#0;   (* Empfangslänge rücksetzen                      *) 

    state := 20;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SNTP_SERVER: S10 INIT';
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
  END_IF;

20:
  IF R_BUF.SIZE > UINT#0 THEN 
    state := 20;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'SNTP_SERVER: S20 REQUEST - Size: ~1';
      LOG_CL.PRINTF[1] := UINT_TO_STRING(R_BUF.SIZE,'%u');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
    (* empfangenes Telegramm mit 00 auffüllen , wenn zu kurz ! und Sendebuffer mit 00 vorbelegen *)
    FOR i := 0 TO 47 DO
      IF INT_TO_UINT(i) > R_BUF.SIZE - UINT#1 THEN
        R_BUF.BUFFER[i] := BYTE#00;
	  END_IF;
      S_BUF.BUFFER[i] := BYTE#00;
    END_FOR;

	R_BUF.SIZE := UINT#0;

    (* Sendedaten aufbereiten *)
    S_BUF.BUFFER[0] := BYTE#2#11100; (* Flags: NO WARNING, NTP VERSION 3 , SERVER      *)
    S_BUF.BUFFER[1] := STRATUM;      (* Peer Clock Stratum:                            *)
    S_BUF.BUFFER[2] := BYTE#10;      (* Peer Polling Intervall 2 hoch 10 = 1024 sek.   *)
    S_BUF.BUFFER[3] := BYTE#16#FB;   (* Peer Clock Precision: -5 = -31,25ms            *) 

    (* Umrechnung SNTP Timestamp Base 1900-01-01 = Unix 1970-01-01 + 2208988800 sekunden*)
    TIMESTAMP_INT := UDINT_TO_DWORD(UDT + UDINT#2208988800);

    (* Sekundenanteile sind als 32 Bit Fractal dargestellt *) 
    (* nur mit veringerte Auflösung berechnen 1/65535 -> Highword verwenden *)
    (* Berechnung des Sekundenanteils: xms * 65535 / 1000 *)
	TIMESTAMP_SEK := DINT_TO_DWORD(DWORD_TO_DINT(SHL_DWORD(INT_TO_DWORD(XMS),16))/DINT#1000);

    TS_B := TIMESTAMP_INT.B3; (* Timestamp Byte 3    *)
    S_BUF.BUFFER[16] := TS_B; (* Reference Timestamp *)
    S_BUF.BUFFER[32] := TS_B; (* Receive   Timestamp *)
    S_BUF.BUFFER[40] := TS_B; (* Transmit  Timestamp *)

    TS_B := TIMESTAMP_INT.B2; (* Timestamp Byte 2    *)
    S_BUF.BUFFER[17] := TS_B; (* Reference Timestamp *)
    S_BUF.BUFFER[33] := TS_B; (* Receive   Timestamp *)
    S_BUF.BUFFER[41] := TS_B; (* Transmit  Timestamp *)

    TS_B := TIMESTAMP_INT.B1; (* Timestamp Byte 1    *)
    S_BUF.BUFFER[18] := TS_B; (* Reference Timestamp *)
    S_BUF.BUFFER[34] := TS_B; (* Receive   Timestamp *)
    S_BUF.BUFFER[42] := TS_B; (* Transmit  Timestamp *)

    TS_B := TIMESTAMP_INT.B0; (* Timestamp Byte 0    *)
    S_BUF.BUFFER[19] := TS_B; (* Reference Timestamp *)
    S_BUF.BUFFER[35] := TS_B; (* Receive   Timestamp *)
    S_BUF.BUFFER[43] := TS_B; (* Transmit  Timestamp *)

    TS_B := TIMESTAMP_SEK.B1; (* Timestamp Byte 1    *)
    S_BUF.BUFFER[20] := TS_B; (* Reference Timestamp *)
    S_BUF.BUFFER[36] := TS_B; (* Receive   Timestamp *)
    S_BUF.BUFFER[44] := TS_B; (* Transmit  Timestamp *)

    TS_B := TIMESTAMP_SEK.B0; (* Timestamp Byte 0    *)
    S_BUF.BUFFER[21] := TS_B; (* Reference Timestamp *)
    S_BUF.BUFFER[37] := TS_B; (* Receive   Timestamp *)
    S_BUF.BUFFER[45] := TS_B; (* Transmit  Timestamp *)

    (* Byte 1-8 von Transmit-Time auf Originate-Time umkopieren *)
    i2 := 40;
    FOR i := 24 TO 31 DO
      S_BUF.BUFFER[i] := R_BUF.BUFFER[i2];
      i2 := i2 +1;
    END_FOR;

    S_BUF.SIZE := UINT#48; (* Daten senden *)

  ELSIF NOT ENABLE AND S_BUF.SIZE = UINT#0 THEN
    IP_STATE := BYTE#4; (* Abmelden *)
    state := 0;
  END_IF;

END_CASE;

t(IN:= IP_C.ERROR > DWORD#0, PT:=T#5s);
IF t.Q THEN
  IP_C.TIME_RESET := TRUE; (* Error Reset *)
END_IF;

(* IP_FIFO *)
IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
IP_C.FIFO:=IP_FIFO.FIFO;
IP_STATE := IP_FIFO.STATE;
IP_ID:=IP_FIFO.ID;

(* revision history
ks	18. oct. 2008	rev 1.0
	original version

ks	20. oct. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0

ks	17. may. 2011	rev 1.2
	automatischer re-connect
*)


(*               SNTP(NTP) Datenstruktur
                                  1                   2                   3
              0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 01-04  |LI | VN  |Mode |    Stratum    |     Poll      |   Precision   |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 05-08  |                          Root  Delay (32 Bit)                 |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 09-12  |                       Root  Dispersion (32 Bit)               |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 13-16  |                     Reference Identifier (32 Bit)             |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 17-24  |                    Reference Timestamp (64 Bit)               |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 25-32  |                    Originate Timestamp (64 Bit)               |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 33-40  |                     Receive Timestamp (64 Bit)                |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 41-48  |                     Transmit Timestamp (64 Bit)               |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 49-52  |                 Key Identifier (optional) (32 Bit)            |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Byte: 53-68  |                 Message Digest (optional) (128 Bit)           |
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
