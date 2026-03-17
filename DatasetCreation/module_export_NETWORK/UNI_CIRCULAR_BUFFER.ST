(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DATA_LOG
*)
(*@KEY@:DESCRIPTION*)
version 1.1		25. jul. 2011
programmer		ks
tested by		ks

UNI_CIRCULAR_BUFFER ist ein FIFO-RING-Buffer der verschiedene Datenelemente als Byte-Array aufnehmen kann.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK UNI_CIRCULAR_BUFFER

(*Group:log*)


VAR
	(*<LOG_MSG :	LOG_MSG;>*)
	(*<_debug_enable :	BOOL := TRUE;>*)
END_VAR


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


(*Group:Default*)


VAR_IN_OUT
	DATA :	oscat_UNI_CIRCULAR_BUFFER_DATA;
END_VAR


VAR
	tmp_dw :	DWORD;
	tmp_dw2 :	DWORD;
	n :	INT;
	n1 :	INT;
	n2 :	INT;
	headersize :	INT := 4;
	cnt :	INT;
	buf_totalsize :	INT := 4096;
	mode_last :	INT;
	idx :	INT;
	ptmp :	INT;
	x :	INT;
	REAL_TO_DW :	REAL_TO_DW;
	DW_TO_REAL :	DW_TO_REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: UNI_CIRCULAR_BUFFER
IEC_LANGUAGE: ST
*)
CASE DATA.D_MODE OF

01:	x := WORD_TO_INT(DATA.D_HEAD AND WORD#16#00FF);(* nur rechtes byte auswerten *)
	CASE x OF
	01:	cnt := LEN(DATA.D_STRING); (* String verarbeiten *)
	02:	cnt := 4; (* Real verarbeiten *)
		REAL_TO_DW(X:=DATA.D_REAL);
		tmp_dw2 := REAL_TO_DW.REAL_TO_DW;
	03:	cnt := 4; (* DWORD verarbeiten *)
		tmp_dw2 := DATA.D_DWORD;
	ELSE
		cnt := 0;
	END_CASE;
	pTmp := 1;

	IF (cnt + HeaderSize) > (buf_totalsize - DATA.BUF_SIZE) THEN (* genug Speicher frei ? *)
		RETURN;
	END_IF;

	mode_last := DATA.D_MODE;
	tmp_dw := SHL(WORD_TO_DWORD(DATA.D_HEAD),16) OR INT_TO_DWORD(cnt);

	(* Header in Buffer eintragen *)
	n1 := 0;
	idx := DATA._Last;
	REPEAT
		n2 := MIN(HeaderSize - n1, buf_totalsize - idx);
		FOR n := 1 TO n2 DO
			tmp_dw := ROL(tmp_dw,8);
			data.BUF[idx] := DWORD_TO_BYTE(tmp_dw);
			idx := idx + 1;
		END_FOR;
		IF idx >= buf_totalsize THEN
			idx := 0;
		END_IF;
		n1 := n1 + n2;
	UNTIL n1 >= HeaderSize
	END_REPEAT;
	
	(* Daten in Buffer eintragen *)
	n1 := 0;
	REPEAT
		n2 := MIN(cnt - n1, buf_totalsize - idx);
		IF x = 1 THEN (* Type String *)
			FOR n := 1 TO n2 DO
				data.BUF[idx] := INT_TO_BYTE(GET_CHAR(DATA.D_STRING,pTmp));
				pTmp := pTmp + 1;
				idx := idx + 1;
			END_FOR;
		ELSE (* REAL oder DWORD *)
			FOR n := 1 TO n2 DO
				tmp_dw2 := ROL(tmp_dw2,8);
				data.BUF[idx] := DWORD_TO_BYTE(tmp_dw2);
				idx := idx + 1;
			END_FOR;
		END_IF;
		IF idx >= buf_totalsize THEN
			idx := 0;
		END_IF;
		n1 := n1 + n2;
	UNTIL n1 >= cnt
	END_REPEAT;
	DATA._Last := idx;

	DATA.BUF_SIZE := DATA.BUF_SIZE + cnt + HeaderSize;
	DATA.BUF_COUNT := DATA.BUF_COUNT + 1;
	DATA.BUF_USED := INT_TO_USINT(100 * DATA.BUF_SIZE / buf_totalsize); (* benützter Speicher in % *)
	DATA.D_MODE := 0;

	(*####################  DEBUG-MESSAGE  ###################################*)
	(*IF _debug_enable THEN
		LOG_CL.NEW_MSG := 'RP: ADD /HEAD ~1 / SIZE ~2 / CNT ~3 / >~4<';
		LOG_CL.PRINTF[1] := WORD_TO_STRING(DATA.D_HEAD,'%04X');
		LOG_CL.PRINTF[2] := INT_TO_STRING(cnt,'%d');
		LOG_CL.PRINTF[3] := INT_TO_STRING(DATA.BUF_COUNT,'%d');
		LOG_CL.PRINTF[4] := DATA.D_STRING;
		CASE x OF
		01:	LOG_CL.PRINTF[4] := DATA.D_STRING;
		02:	LOG_CL.PRINTF[4] := REAL_TO_STRING(DATA.D_REAL,'%f');
		03:	LOG_CL.PRINTF[4] := DWORD_TO_STRING(DATA.D_DWORD,'%08X');
		ELSE
			LOG_CL.PRINTF[4] := '';
		END_CASE;
		LOG_MSG();
	END_IF;*)
	(*########################################################################*)

10..12: (* ------ Daten aus buffer auslesen und optional löschen *)
	IF DATA.D_MODE <> 11 THEN
		IF DATA.BUF_COUNT = 0 THEN RETURN; END_IF;
		DATA._GetEnd := DATA._First;(* index des ältesten eintrags merken *)
		mode_last := DATA.D_MODE;

		(* Header aus Buffer lesen *)
		n1 := 0;
		tmp_dw := DWORD#0;
		idx := DATA._GetEnd;
		REPEAT
			n2 := MIN(HeaderSize - n1, buf_totalsize - idx);
			FOR n := 1 TO n2 DO
				tmp_dw := ROL(tmp_dw,8) OR BYTE_TO_DWORD(data.BUF[idx]);
				idx := idx + 1;
			END_FOR;
			IF idx >= buf_totalsize THEN
				idx := 0;
			END_IF;
			n1 := n1 + n2;
		UNTIL n1 >= HeaderSize
		END_REPEAT;
		DATA._GetEnd := idx;

		DATA._GetStart := DATA._GetEnd;
		cnt := DWORD_TO_INT(tmp_dw AND DWORD#16#0000_FFFF);
		DATA.D_HEAD := DWORD_TO_WORD(SHR(tmp_dw,16));

		x := WORD_TO_INT(DATA.D_HEAD AND WORD#16#00FF);(* nur rechtes byte auswerten *)
		IF x = 1 THEN
			DATA.D_STRING := '';
		END_IF;

		(* Daten aus Buffer lesen *)
		tmp_dw2 := DWORD#0;
		n1 := 0;
		idx := DATA._GetEnd;
		REPEAT
			n2 := MIN(cnt - n1, buf_totalsize - idx);
			IF x = 1 THEN (* Type String *)
				FOR n := 1 TO n2 DO
					DATA.D_STRING := CONCAT(DATA.D_STRING,BYTE_TO_STRING(data.BUF[idx],'%c'));
					idx := idx + 1;
				END_FOR;
			ELSE (* REAL oder DWORD *)
				FOR n := 1 TO n2 DO
					tmp_dw2 := ROL(tmp_dw2,8) OR BYTE_TO_DWORD(data.BUF[idx]);
					idx := idx + 1;
				END_FOR;
			END_IF;
			IF idx >= buf_totalsize THEN
				idx := 0;
			END_IF;
			n1 := n1 + n2;
		UNTIL n1 >= cnt
		END_REPEAT;
		DATA._GetEnd := idx;

		CASE x OF
		02:	DW_TO_REAL(X:=tmp_dw2); (* Real verarbeiten *)
			DATA.D_REAL:=DW_TO_REAL.DW_TO_REAL;
		03:	DATA.D_DWORD := tmp_dw2; (* DWORD eintragen *)
		END_CASE;
		DATA.D_MODE := 0;

		(*####################  DEBUG-MESSAGE  ###################################*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'RP: READ /HEAD ~1 / SIZE ~2 / CNT ~3 / >~4<';
			LOG_CL.PRINTF[1] := WORD_TO_STRING(DATA.D_HEAD,'%04X');
			LOG_CL.PRINTF[2] := INT_TO_STRING(cnt,'%d');
			LOG_CL.PRINTF[3] := INT_TO_STRING(DATA.BUF_COUNT,'%d');
			CASE x OF
			01:	LOG_CL.PRINTF[4] := DATA.D_STRING;
			02:	LOG_CL.PRINTF[4] := REAL_TO_STRING(DATA.D_REAL,'%f');
			03:	LOG_CL.PRINTF[4] := DWORD_TO_STRING(DATA.D_DWORD,'%08X');
			ELSE
				LOG_CL.PRINTF[4] := '';
			END_CASE;
			LOG_MSG();
		END_IF;*)
		(*########################################################################*)
	END_IF;

	IF (mode_last = 10 AND DATA.D_MODE = 11) OR (mode_last = 12 AND DATA.D_MODE = 0) THEN (* löschen nur direkt nach lesen möglich *)
		mode_last := DATA.D_MODE;
		DATA.BUF_SIZE := DATA.BUF_SIZE - cnt - HeaderSize;
		DATA.BUF_COUNT := DATA.BUF_COUNT - 1;
		DATA._First := DATA._GetEnd;
		DATA.BUF_USED := INT_TO_USINT(100 * DATA.BUF_SIZE / buf_totalsize); (* benützer Speicher in % *)
		DATA.D_MODE := 0;

		(*####################  DEBUG-MESSAGE  ###################################*)
		(*IF _debug_enable THEN
			LOG_CL.NEW_MSG := 'RP: DEL /HEAD ~1 / SIZE ~2 / CNT ~3 / >~4<';
			LOG_CL.PRINTF[1] := WORD_TO_STRING(DATA.D_HEAD,'%04X');
			LOG_CL.PRINTF[2] := INT_TO_STRING(cnt,'%d');
			LOG_CL.PRINTF[3] := INT_TO_STRING(DATA.BUF_COUNT,'%d');
			CASE x OF
			01:	LOG_CL.PRINTF[4] := DATA.D_STRING;
			02:	LOG_CL.PRINTF[4] := REAL_TO_STRING(DATA.D_REAL,'%f');
			03:	LOG_CL.PRINTF[4] := DWORD_TO_STRING(DATA.D_DWORD,'%08X');
			ELSE
				LOG_CL.PRINTF[4] := '';
			END_CASE;
			LOG_MSG();
		END_IF;*)
		(*########################################################################*)
	END_IF;

99:	(* Buffer reset - alles löschen *)
	DATA._First := INT#0;
	DATA._Last := INT#0;
	DATA._GetStart := INT#0;
	DATA._GetEnd := INT#0;
	DATA.BUF_COUNT := INT#0;
	DATA.BUF_SIZE := INT#0;
	DATA.BUF_USED := USINT#0;
	DATA.D_STRING := '';
	DATA.D_DWORD := DWORD#0;
	DATA.D_REAL := 0.0;
	DATA.D_HEAD := WORD#0;
	DATA.D_MODE := 0;
	mode_last := 0;
END_CASE;

(* revision history
ks	01. jan. 2011	rev 1.0
	original version
ks	25. july. 2011	rev 1.1
	neuen MODE 12 hinzugefügt
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
