(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.1 20. oct. 2009
programmer 	ks
tested by	ks

READ_HTTP wertet die Informationen einer HTTP-Request aus, und stellt die Daten zu Verfügung.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK READ_HTTP

(*Group:Default*)


VAR_INPUT
	SIZE :	UINT;
	POS :	INT;
	SRC :	STRING;
END_VAR


VAR_IN_OUT
	PT :	oscat_NW_BUF_LONG;
END_VAR


VAR_OUTPUT
	READ_HTTP :	oscat_STRING250;
END_VAR


VAR
	index :	INT;
	s1 :	INT;
	e1 :	INT;
	stop :	INT;
	BUFFER_SEARCH :	BUFFER_SEARCH_NW;
	BUFFER_TO_STRING :	BUFFER_TO_STRING_NW;
END_VAR


(*@KEY@: WORKSHEET
NAME: READ_HTTP
IEC_LANGUAGE: ST
*)
STOP := UINT_TO_INT(SIZE) - 1;

IF LEN(SRC) = 0 THEN
(* wenn kein Suchbegriff vorhanden ist, dann den HTTP-STATUS auswerten *) 
  SRC := 'HTTP/'; (* neuer Suchbegriff *) 
ELSE
  (* gesuchten Parametertext ergänzen *)
  SRC := CONCAT(SRC,': ');
END_IF;

BUFFER_SEARCH(size:=size,str:=SRC,pos:=pos,ign:=TRUE,pt:=pt);
pt:=BUFFER_SEARCH.pt;
S1:=BUFFER_SEARCH.BUFFER_SEARCH;

IF S1 >= 0 THEN (* Text found *)
  E1 := S1;

  (* search start of line *)
  INDEX := S1 - 1;
  WHILE (INDEX > 0) DO
    IF pt[INDEX] < BYTE#32 THEN EXIT; END_IF;
    S1 := S1 - 1;
    INDEX := INDEX - 1;
  END_WHILE;

  (* search end of line *)
  INDEX := E1 + 1;
  WHILE (INDEX <= STOP) DO
    IF pt[INDEX] < BYTE#32 THEN EXIT; END_IF;
    E1 := E1 + 1;
    INDEX := INDEX + 1;
  END_WHILE;

  s1 := s1 + LEN(SRC); (* 'suchbegriff: ' nicht mitkopieren *)

  (* copy string *)
  BUFFER_TO_STRING.size  := size;
  BUFFER_TO_STRING.start := INT_TO_UINT(s1);
  BUFFER_TO_STRING.stop  := INT_TO_UINT(e1);
  BUFFER_TO_STRING.pt    := pt;
  BUFFER_TO_STRING();
  READ_HTTP := BUFFER_TO_STRING.BUFFER_TO_STRING;
  pt   := BUFFER_TO_STRING.pt;

ELSE
  READ_HTTP := '';
END_IF;


(* revision history

ks	18. oct. 2008	rev 1.0
	original version

ks	20. oct. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
