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

HTML_ENCODE checks a string if it contains reserved HTML characters and converts them to alternative html coding.
& is replaced by &amp; ("Ampersand")
< is replaced by &lt; ("lower than")
> is replaced by &gt; ("greater than")
" is replaced by &quot; ("Quote")
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HTML_ENCODE

(*Group:Default*)


VAR_INPUT
	IN :	oscat_STRING250;
	M :	BOOL;
END_VAR


VAR_OUTPUT
	HTML_ENCODE :	oscat_STRING250;
END_VAR


VAR
	pt_out :	oscat_aB1_255;
	pos_in :	INT;
	pos_out :	INT;
	stop :	INT;
	B :	INT;
	tmp :	oscat_STRING10;
	i :	INT;
	BUF_TO_STRING :	BUF_TO_STRING;
	CHARNAME :	CHARNAME;
	CODE :	CODE;
END_VAR


(*@KEY@: WORKSHEET
NAME: HTML_ENCODE
IEC_LANGUAGE: ST
*)
(* scan the input string and convert unallowed characters *)
pos_in := 1;
stop := LEN(in);
FOR pos_out := 1 TO 250 DO
	IF pos_in > stop THEN EXIT; END_IF;
    B := GET_CHAR(IN,pos_in);
	CASE B OF
		34: (* " detected *)
			IF pos_out > 244 THEN EXIT; END_IF;
			pt_out[pos_out] := BYTE#38;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#113;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#117;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#111;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#116;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#59;
		38: (* & detected *)
			IF pos_out > 245 THEN EXIT; END_IF;
			pt_out[pos_out] := BYTE#38;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#97;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#109;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#112;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#59;
		60: (* < detected *)
			IF pos_out > 246 THEN EXIT; END_IF;
			pt_out[pos_out] := BYTE#38;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#108;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#116;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#59;
		62: (* > detected *)
			IF pos_out > 246 THEN EXIT; END_IF;
			pt_out[pos_out] := BYTE#38;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#103;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#116;
			pos_out := pos_out + 1;
			pt_out[pos_out] := BYTE#59;
	ELSE
		IF M AND B > 127 THEN
            CHARNAME(C:=INT_TO_BYTE(B));
			tmp := CHARNAME.CHARNAME;
			(* exit if output string has not enough space *)
			IF pos_out + LEN(tmp) + 2 <= 250 THEN
				pt_out[pos_out] := BYTE#38;
				pos_out := pos_out + 1;
				FOR i := 1 TO LEN(tmp) DO
                    CODE(STR:=tmp,POS:=i);
					pt_out[pos_out] := CODE.CODE;
					pos_out := pos_out + 1;
				END_FOR;
				pt_out[pos_out] := BYTE#59;
			END_IF;
		ELSE
  		   pt_out[pos_out] := INT_TO_BYTE(B);
		END_IF;
	END_CASE;
	(* increment in by 1 *)
	pos_in := pos_in + 1;
END_FOR;

pos_out := pos_out - 1;

FOR pos_in := 0 TO 1 DO
  BUF_TO_STRING.REQ        := pos_in>0;
  BUF_TO_STRING.BUF_FORMAT := TRUE;
  BUF_TO_STRING.BUF_OFFS   := DINT#0;
  BUF_TO_STRING.BUF_CNT    := INT_TO_DINT(pos_out);
  BUF_TO_STRING.BUFFER     := pt_out;
  BUF_TO_STRING.DST        := HTML_ENCODE;
  BUF_TO_STRING();
  pt_out  := BUF_TO_STRING.BUFFER;
  HTML_ENCODE := BUF_TO_STRING.DST;
END_FOR;

(* revision history
hm		3. mai. 2008	rev 1.0
	original version

hm		10. mai. 2008	rev 1.1
	stringlength 250
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
