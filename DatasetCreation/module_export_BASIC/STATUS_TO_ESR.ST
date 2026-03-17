(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.0	6 oct 2006
programmer 	hugo
tested by	tobias

status_to_esr creates esr data from a status byte.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK STATUS_TO_ESR

(*Group:Default*)


VAR_INPUT
	STATUS :	BYTE;
	ADRESS :	oscat_STRING10;
	DT_IN :	UDINT;
	TS :	TIME;
END_VAR


VAR_OUTPUT
	STATUS_TO_ESR :	oscat_esr_data;
END_VAR


(*@KEY@: WORKSHEET
NAME: STATUS_TO_ESR
IEC_LANGUAGE: ST
*)
IF status < BYTE#100 THEN
	status_to_ESR.typ := BYTE#1;
ELSIF status < BYTE#200 THEN
	status_to_ESR.typ := BYTE#2;
ELSE
	status_to_ESR.typ := BYTE#3;
END_IF;
status_to_ESR.adress:= adress;
status_to_ESR.DS := DT_in;
status_to_ESR.TS := TS;
status_to_ESR.data[0] := status;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
