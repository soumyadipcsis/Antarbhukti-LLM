(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DRIVER
*)
(*@KEY@:DESCRIPTION*)
version 1.0		06. dec. 2009
programmer 		ks
tested by		ks
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IRTRANS_SND_1

(*Group:Default*)


VAR_INPUT
	DEV_CODE :	STRING;
	KEY_CODE :	STRING;
	IN :	BOOL;
	T_REPEAT :	TIME;
END_VAR


VAR_OUTPUT
	KEY :	BYTE;
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	S_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR
	skey :	STRING;
	size :	INT;
	str :	STRING;
	i :	INT;
	t :	TON;
	k :	BYTE;
	lk :	BYTE;
	d :	BOOL;
	i2 :	INT;
	CODE :	CODE;
END_VAR


(*@KEY@: WORKSHEET
NAME: IRTRANS_SND_1
IEC_LANGUAGE: ST
*)
d := IP_C.C_STATE > BYTE#127 AND (IP_C.MAILBOX[1] > BYTE#0 OR IP_C.C_MODE <> BYTE#5);
IF NOT d THEN RETURN; END_IF;

t(IN:= lk = k , PT:=T_REPEAT);

IF S_BUF.SIZE = UINT#0 THEN
	IF IN THEN
		skey := KEY_CODE; k := BYTE#1;
	ELSE
		lk := BYTE#0;
		KEY := BYTE#0;
		RETURN; (* beenden wenn kein Key aktiv *)
	END_IF;

	IF lk <> k OR T.Q THEN (* anderer Key oder repeat wartezeit abgelaufen *)
		str := CONCAT('snd ',dev_code);
		str := CONCAT(str,',');
		str := CONCAT(str,skey);
		size := LEN(str);
		FOR i := 1 TO size DO
			i2 := i - 1;
			CODE(STR:=str,POS:=i);
			S_BUF.BUFFER[i2] := CODE.CODE;
		END_FOR;
		S_BUF.SIZE := INT_TO_UINT(size); (* Sendelänge eintragen *)
		KEY := k;
		lk := k; (* letzten Key speichern *)
		t(IN:=FALSE); (* Reset Time *)
	END_IF;
END_IF;

(* revision history
hm	6. dec 2009		rev 1.0
	original version
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
