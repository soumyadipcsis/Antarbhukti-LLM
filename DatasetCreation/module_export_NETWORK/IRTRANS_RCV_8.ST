(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DRIVER
*)
(*@KEY@:DESCRIPTION*)
version 1.3	06. dec. 2009
programmer 	hugo
tested BY	oscat
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IRTRANS_RCV_8

(*Group:Default*)


VAR_INPUT
	CMD :	BOOL;
END_VAR


VAR_IN_OUT
	DEV :	STRING;
	KEY :	STRING;
END_VAR


VAR_INPUT
	DEV_CODE :	STRING;
	KEY_CODE_0 :	STRING;
	KEY_CODE_1 :	STRING;
	KEY_CODE_2 :	STRING;
	KEY_CODE_3 :	STRING;
	KEY_CODE_4 :	STRING;
	KEY_CODE_5 :	STRING;
	KEY_CODE_6 :	STRING;
	KEY_CODE_7 :	STRING;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	Q4 :	BOOL;
	Q5 :	BOOL;
	Q6 :	BOOL;
	Q7 :	BOOL;
END_VAR


VAR
	decode :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: IRTRANS_RCV_8
IEC_LANGUAGE: ST
*)
decode := cmd AND EQ_STRING(dev_code,dev);

Q0 := EQ_STRING(key,key_code_0) AND decode;
Q1 := EQ_STRING(key,key_code_1) AND decode;
Q2 := EQ_STRING(key,key_code_2) AND decode;
Q3 := EQ_STRING(key,key_code_3) AND decode;
Q4 := EQ_STRING(key,key_code_4) AND decode;
Q5 := EQ_STRING(key,key_code_5) AND decode;
Q6 := EQ_STRING(key,key_code_6) AND decode;
Q7 := EQ_STRING(key,key_code_7) AND decode;

(* revision history
hm	2. jan 2008		rev 1.0
	original version

hm	17. oct 2008	rev 1.1
	improved performance

hm	19. oct. 2008	rev 1.2
	changed input device_code to dev_code and device to dev for compatibility reasons

hm	06. dec. 2008	rev 1.3
	IRTRANS_1 renamed to IRTRANS_RCV_8

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
