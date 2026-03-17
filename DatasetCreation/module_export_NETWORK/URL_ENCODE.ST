(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)
version 1.1		10. may. 2010
programmer 		hugo
tested by		hugo

URL_ENCODE checks a string if it contains only non reserved characters for an url.
the non reserved characters are : [A..Z], [a..z], [0..9], -_.~
if reserved characters are found then these characters are converted to %HH while HH is the Hexadezimal representation of the character in Alphabetic Letters.
for example the reserved character # will be converted to '%23'.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK URL_ENCODE

(*Group:Default*)


VAR_INPUT
	IN :	oscat_STRING250;
END_VAR


VAR_OUTPUT
	URL_ENCODE :	oscat_STRING250;
END_VAR


VAR
	pos_in :	INT;
	pos_out :	INT;
	stop :	INT;
	tb :	BYTE;
	pt_out :	oscat_aB1_255;
	char :	BYTE;
	BUF_TO_STRING :	BUF_TO_STRING;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: URL_ENCODE
IEC_LANGUAGE: ST
*)
(* scan the input string and convert unallowed characters *)
pos_in := 1;
stop := LEN(in);
FOR pos_out := 1 TO 250 DO
    char := INT_TO_BYTE(GET_CHAR(IN,pos_in));
	IF pos_in > stop THEN
		EXIT;
	ELSIF IS_URLCHR(char) THEN
		pt_out[pos_out] := char;
		(* increment in by 1 *)
		pos_in := pos_in + 1;
	ELSE
		(* cannot fit 3 digits, exit *)
		IF pos_out > 248 THEN EXIT; END_IF;
		(* invalid character that needs to be converted *)
		pt_out[pos_out] := BYTE#37;    (* start with % sign *)
		pos_out := pos_out + 1;
		(* need to add the two hex digits *)
		tb := SHR_BYTE(char,4);
		IF tb > BYTE#9 THEN
			pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#55);
		ELSE
			pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#48);
		END_IF;
		pos_out := pos_out + 1;
		tb := char AND BYTE#16#0F;
		IF tb > BYTE#9 THEN
			pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#55);
		ELSE
			pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#48);
		END_IF;
		(* increment in and out because out has to move 3 digits *)
		pos_in := pos_in + 1;
	END_IF;
END_FOR;

pos_out := pos_out - 1;

FOR i := 0 TO 1 DO
  BUF_TO_STRING.REQ        := i>0;
  BUF_TO_STRING.BUF_FORMAT := TRUE;
  BUF_TO_STRING.BUF_OFFS   := DINT#0;
  BUF_TO_STRING.BUF_CNT    := INT_TO_DINT(pos_out);
  BUF_TO_STRING.BUFFER     := pt_out;
  BUF_TO_STRING.DST        := URL_ENCODE;
  BUF_TO_STRING();
  pt_out  := BUF_TO_STRING.BUFFER;
  URL_ENCODE := BUF_TO_STRING.DST;
END_FOR;

(* revision history
hm	27. apr. 2008	rev 1.0
	original version

ks	10. mai. 2008	rev 1.1
	stringlength 250

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
