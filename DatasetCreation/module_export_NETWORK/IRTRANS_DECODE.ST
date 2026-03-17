(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DRIVER
*)
(*@KEY@:DESCRIPTION*)

version 1.2		06. dec. 2009
programmer 		ks
tested by		ks
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IRTRANS_DECODE

(*Group:Default*)


VAR_OUTPUT
	CMD :	BOOL;
	DEV :	STRING;
	KEY :	STRING;
	ERROR :	BOOL;
END_VAR


VAR_IN_OUT
	IP_C :	oscat_IP_C;(*IP_Control Verwaltungsstruktur*)
	R_BUF :	oscat_NETWORK_BUFFER;
END_VAR


VAR
	i :	INT;
	stop :	INT;
	received_string :	STRING;
	char :	STRING;
	CHR_TO_STRING :	CHR_TO_STRING;
	z :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: IRTRANS_DECODE
IEC_LANGUAGE: ST
*)

i := UINT_TO_INT(R_BUF.SIZE);
(* do nothing if the buffer is empty *)
IF i >= 5 AND (i <= 82) AND IP_C.MAILBOX[1] <> z THEN (* maximum size is 82 bytes (last two chars = $R$N) *)
	error := TRUE;
	i := i - 1; (* Index-Basis 0 *)

	(* check if last two characters are $R$N 13, 10 *)
	IF R_BUF.BUFFER[i] <> BYTE#10 THEN RETURN; END_IF;
	i := i - 1;
	IF R_BUF.BUFFER[i] <> BYTE#13 THEN RETURN; END_IF;
	i := i - 1;

	stop := 0;
	received_string := '';

	WHILE stop <= i DO
		CHR_TO_STRING(C:=R_BUF.BUFFER[stop]);
		char := CHR_TO_STRING.CHR_TO_STRING;
		received_string := CONCAT(received_string,char);
		stop := stop + INT#1;
	END_WHILE;

	stop := FIND(received_string,',');
	IF stop > 0 AND stop - 1 < i THEN
		DEV := LEFT(received_string,stop - 1);
		key := RIGHT(received_string,i - stop + 1);
		IF LEN(DEV) = 0 OR LEN(key) = 0 THEN RETURN; END_IF;
		cmd := TRUE;
		error := FALSE;
	END_IF;
ELSE
	cmd := FALSE;
	error := FALSE;
END_IF;

z := IP_C.MAILBOX[1];

(* revision history
ks	18. oct. 2008	rev 1.0
	original version
ks	20. oct. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0
ks	06. dec. 2009	rev 1.2
	Codeanpassung für IRTRANS_SERVER
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
