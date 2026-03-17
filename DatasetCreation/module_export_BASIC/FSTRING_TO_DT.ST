(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	24. sep. 2008
programmer 	hugo
tested by	oscat

FSTRING_TO_DT converts Formatted String into a DT value.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FSTRING_TO_DT

(*Group:Default*)


VAR_INPUT
	SDT :	oscat_STRING60;
	FMT :	oscat_STRING60;
	IGNORE :	oscat_STRING1 := '*';
	FCHAR :	oscat_STRING1 := '#';
END_VAR


VAR_OUTPUT
	FSTRING_TO_DT :	UDINT;
END_VAR


VAR
	c :	oscat_STRING1;
	tmp :	oscat_STRING20;
	tmp1 :	oscat_STRING1;
	tmp2 :	INT;
	end :	INT;
	dy :	INT;
	dm :	INT;
	dd :	INT;
	th :	INT;
	tm :	INT;
	ts :	INT;
	FSTRING_TO_MONTH :	FSTRING_TO_MONTH;
	IS_NUM :	IS_NUM;
END_VAR


(*@KEY@: WORKSHEET
NAME: FSTRING_TO_DT
IEC_LANGUAGE: ST
*)
dy := 1970;
dm := 1;
dd := 1;
th := 0;
tm := 0;
ts := 0;
FSTRING_TO_DT := UDINT#0;

(* scan input string *)
WHILE (LEN(fmt)>0) DO
	c := LEFT(fmt,1);
	IF EQ_STRING(c,ignore) THEN
		(* skip ignore characters *)
		fmt := DELETE(fmt,1,1);
		IF LEN(sdt)>0 THEN sdt := DELETE(sdt,1,1); END_IF;
	ELSIF EQ_STRING(C,fchar) THEN
		(* format character found skip format char and read identifier *)
		(* store format identifier in c and skip to next char in fmt *)
		IF LEN(fmt) >=2 THEN
		    c := MID(fmt,1,2);
		    fmt := DELETE(fmt,2,1);
        ELSE
		    c := '';
			fmt := '';
		END_IF;
		(* extract the substring until the end of sdt or to next char of fmt *)
		IF LEN(fmt) = 0 THEN
			tmp := sdt;
		ELSE
		    dm := dm;
			(* serach for end of substring *)
            tmp1 := LEFT(fmt,1);
			end := FIND(sdt,tmp1)-1;
            IF end > 0 AND end <= LEN(sdt) THEN
			    tmp := LEFT(sdt, end);
            ELSE
			    tmp := '';
            END_IF;
			sdt := DELETE(sdt, end,1);
        END_IF;

        IS_NUM(str:=tmp);
        IF IS_NUM.IS_NUM THEN
		    tmp2 := STRING_TO_INT(tmp);
        ELSE
		    tmp2 := 0;
	    END_IF;

		(* extract information from substring *)
		IF EQ_STRING(c,'Y') THEN
			dy := tmp2;
			IF dy < 100 THEN dy := dy + 2000; END_IF;
		ELSIF EQ_STRING(c,'M') THEN
			dm := tmp2;
		ELSIF EQ_STRING(c,'N') THEN
		    dm := dm;
            FSTRING_TO_MONTH(MTH:=tmp,LANG:=0);
            dm := FSTRING_TO_MONTH.FSTRING_TO_MONTH;
		ELSIF EQ_STRING(c,'D') THEN
			dd := tmp2;
		ELSIF EQ_STRING(c,'h') THEN
			th := tmp2;
		ELSIF EQ_STRING(c,'m') THEN
			tm := tmp2;
		ELSIF EQ_STRING(c,'s') THEN
			ts := tmp2;
		END_IF;
	ELSE
        tmp1 := LEFT(sdt,1);
	    IF EQ_STRING(c,tmp1) THEN
		    (* skip matching characters *)
		    fmt := DELETE(fmt,1,1);
		    sdt := DELETE(sdt,1,1);
	    ELSE
		    RETURN;
  	    END_IF;
	END_IF;
END_WHILE;

FSTRING_TO_DT := SET_DT(dy,dm,dd,th,tm,ts);

(* revision histroy
hm	24. sep. 2008	rev 1.0
	original release


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
