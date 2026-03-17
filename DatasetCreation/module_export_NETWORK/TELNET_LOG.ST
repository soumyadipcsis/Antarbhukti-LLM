(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)
version 1.1	03. Dec. 2011
programmer 	ks
tested BY	ks

TELNET_LOG sendet alle Texte vom LOG_BUFFER an eine TELNET_Konsole

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TELNET_LOG

(*Group:IN_OUT*)


VAR_INPUT
	ENABLE :	BOOL;
	OPTION :	BYTE := BYTE#2#1000_1100;
	PORT :	WORD := WORD#23;
END_VAR


VAR_OUTPUT
	READY :	BOOL;
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;
	S_BUF :	oscat_NETWORK_BUFFER;
	LOG_CL :	us_LOG_CONTROL;
END_VAR


VAR
	TELNET_PRINT :	TELNET_PRINT;
	done :	BOOL;
	init :	BOOL;
	watchdog :	TON;
	ci :	INT;
	pi :	INT;
	pi_last :	INT;
	send :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TELNET_LOG
IEC_LANGUAGE: ST
*)
IF NOT init THEN
	init := TRUE;
	IF OPTION > BYTE#0 THEN
		TELNET_PRINT.OPTION := OPTION;
	END_IF;
	IF PORT > WORD#0 THEN (* bei portvorgabe wird der standardport überschrieben *)
		TELNET_PRINT.PORT := PORT;
	END_IF;
  	WATCHDOG.PT := T#1ms;
END_IF;

WATCHDOG(IN:=FALSE); (* Timer stoppen *)

ci := LOG_CL.IDX;

(* CONNECT_OFF Flanke auswerten *)
IF IP_C.C_STATE = BYTE#1 THEN
	pi := 0;
	init := FALSE;
END_IF;

REPEAT
	IF pi <> ci AND IP_C.C_STATE > BYTE#127 THEN
		IF pi = 0 AND LOG_CL.RING_MODE THEN pi := ci; END_IF;
		pi_last := pi;
		pi := pi + 1;
		IF pi > LOG_CL.SIZE THEN pi := 1; END_IF;
		SEND := TRUE;
	ELSE
		SEND := FALSE;
	END_IF;

	TELNET_PRINT(	IP_C := IP_C,
					S_BUF := S_BUF,
					ENABLE := ENABLE,
					SEND := SEND,
					TEXT := LOG_CL.MSG[pi],
					BACK_COLOR := DWORD_TO_BYTE(SHL(LOG_CL.MSG_OPTION[pi],8)),
					FRONT_COLOR := DWORD_TO_BYTE(LOG_CL.MSG_OPTION[pi] ));
	READY := TELNET_PRINT.READY;
	done  := TELNET_PRINT.DONE;
	IP_C  := TELNET_PRINT.IP_C;
	S_BUF := TELNET_PRINT.S_BUF;

	IF SEND AND NOT done THEN
		pi := pi_last;
	END_IF;

	WATCHDOG(IN:=TRUE);

UNTIL (WATCHDOG.Q OR NOT done )
END_REPEAT;

(* revision history
ks	14. aug. 2009	rev 1.0
	original version

ks	03. dec. 2011	rev 1.1
	neue parameter und initialisierung optimiert

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
