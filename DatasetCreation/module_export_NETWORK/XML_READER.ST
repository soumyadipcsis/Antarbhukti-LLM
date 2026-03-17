(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)

version 1.2		10. mai 2010
programmer 		ks
tested by		ks

XML_READER ermöglicht das serielle Parsen und die Auswertung von XML_Elementen in einem Buffer
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK XML_READER

(*Group:debug*)


VAR_EXTERNAL
	(*<LOG_CL :	us_LOG_CONTROL;>*)
END_VAR


VAR
	(*<_debug_enable :	BOOL := TRUE;>*)
	(*<LOG_MSG :	LOG_MSG;>*)
END_VAR


(*Group:in_out*)


VAR_IN_OUT
	CTRL :	oscat_XML_CONTROL;
	BUF :	oscat_NW_BUF_LONG;
END_VAR


(*Group:var*)


VAR
	BUFFER_SEARCH :	BUFFER_SEARCH_NW;
	BUFFER_TO_STRING :	BUFFER_TO_STRING_NW;
	FINDB :	FINDB;
	INDEX :	INT;
	INDEX2 :	INT;
	STOP :	INT;
	MODE :	INT;
	COMMAND :	WORD;
	C :	BYTE;
	S1 :	INT;
	E1 :	INT;
	PATH_OVERFLOW :	BOOL;
	EMPTY_TAG :	BOOL;
	S_CODE :	oscat_STRING10;
	E_CODE :	oscat_STRING10;
	WATCHDOG :	TON;
END_VAR


(*@KEY@: WORKSHEET
NAME: Code
IEC_LANGUAGE: ST
*)
(*  

TYP
00 = UNBEKANNT
01 = ELEMENT (STANDARD)
02 = CLOSE ELEMENT 
03 = TEXT
04 = ATTRIBUTE
05 = ELEMENT (PROCESSING INSTRUCTION) 

12 = !CDATA
13 = !COMMENT
14 = !DTD ELEMENT (Document Type Declarations )

98 = WATCHDOG
99 = ENDE

Bei Typ 02 werden keine Blockdaten ausgegeben !

*)

(* ---------- Init -------------- *)
IF BIT_OF_DWORD(WORD_TO_DWORD(CTRL.COMMAND),15) THEN
  COMMAND := CTRL.COMMAND;
  CTRL.COMMAND := WORD#0;

  INDEX := UINT_TO_INT(CTRL.START_POS);
  STOP := UINT_TO_INT(CTRL.STOP_POS);
  MODE := 100;
  PATH_OVERFLOW := FALSE;

  CTRL.TYP := 0;
  CTRL.COUNT := UINT#00;
  CTRL.LEVEL := UINT#00;
  CTRL.ATTRIBUTE := '';
  CTRL.ELEMENT := '';
  CTRL.PATH := '';
  CTRL.VALUE := '';

  WATCHDOG.PT := CTRL.WATCHDOG;
END_IF;

(*----------------------------------------------- *)

IF INDEX < 0 THEN RETURN;END_IF;

CTRL.BLOCK1_START := UINT#0;
CTRL.BLOCK1_STOP := UINT#0;
CTRL.BLOCK2_START := UINT#0;
CTRL.BLOCK2_STOP := UINT#0;

WATCHDOG(IN:=FALSE); (* Timer stoppen *)

WHILE (TRUE) DO

  (* -------------- WATCHDOG ------------------ *)
  WATCHDOG(IN:=CTRL.WATCHDOG > T#0s);
  IF WATCHDOG.Q THEN
    CTRL.TYP := 98;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'WATCHDOG:';
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)
    RETURN;
  END_IF;

  (* -------------- PARSING END ------------------ *)
  IF INDEX>STOP THEN

    CTRL.COUNT := CTRL.COUNT + UINT#1;
    CTRL.TYP := 99;
    (*####################  DEBUG-MESSAGE  ###################################*)
    (*IF _debug_enable THEN
      LOG_CL.NEW_MSG := 'EX: #T:~1 #C:~2 #P:~6 #L:~7';
      LOG_CL.PRINTF[1] := INT_TO_STRING(CTRL.TYP,'%d');
      LOG_CL.PRINTF[2] := UINT_TO_STRING(CTRL.COUNT,'%u');
      LOG_CL.PRINTF[6] := CTRL.PATH;
      LOG_CL.PRINTF[7] := UINT_TO_STRING(CTRL.LEVEL,'%u');
      LOG_MSG();
    END_IF;*)
    (*########################################################################*)

    MODE  :=0; (* Schritt ruecksetzen *)
    INDEX :=0; (* Abarbeitung stoppen *)
    RETURN;
  END_IF;

  CASE MODE OF
 
  100: (* ---------- ELEMENT SECTION ------------------ *)

    (* search begin of element *)
    s1 := 0;
    e1 := 0;
    WHILE (INDEX <= STOP) DO
      IF BUF[INDEX]=BYTE#60 THEN (* '<' TagBegin *)
        INDEX := INDEX +1;
        C := BUF[INDEX];
        IF C=BYTE#47 THEN    (* '/' TagTerm *)
          MODE := 300;       (* End Element Section *)
        ELSIF C=BYTE#33 THEN (* '!' for Special Section *)
          INDEX := INDEX +1;
          MODE := 500;
        ELSE
          s1 := INDEX;
        END_IF;
        EXIT;
      END_IF;
      INDEX := INDEX+1;
    END_WHILE;

    (* analyse element *)
    CTRL.TYP := 0; (* TYP löschen *)
    IF s1>0 THEN
      WHILE (INDEX <= STOP AND e1=0) DO
        C := BUF[INDEX];
        (* whitespace zeichen = Element with Attributes *)
	    IF C<=BYTE#32 THEN 

          (* suche nächstes druckbares zeichen *)
          INDEX2 := INDEX;
          WHILE (INDEX2 <= STOP) AND (BUF[INDEX2]<=BYTE#32) DO
            INDEX2 := INDEX2 + 1;
          END_WHILE;
		  IF BUF[INDEX2]=BYTE#47 THEN (* pruefe auf leeres Element '/' *)
			  INDEX := INDEX2;
			  e1 := INDEX-2;
              CTRL.TYP := 1; (* struktur-element *)
   		      MODE := 300;   (* Close Element *) 
              EXIT;
          END_IF;

          e1 := INDEX-1;  
          CTRL.TYP := 1; (* Element mit Attribute *)
		  MODE := 400; 

        ELSIF C=BYTE#62 THEN (* '>' TagEnd *)

          (* pruefe auf leeres Element <xx/> *)
		  INDEX2 := INDEX-1;
		  IF BUF[INDEX2]=BYTE#47 THEN (* TagTerm '/' *)
            e1 := INDEX2-1;  
            CTRL.TYP := 1;
			EMPTY_TAG := TRUE; (* EMPTY TAG Mode *)
  	        MODE := 200;      (* TEXT Element *) 
            EXIT;
          END_IF;

          e1 := INDEX-1;  
          INDEX2 := INDEX + 1;
 
          (* untersuche nachfolgendes Element *)
          WHILE (INDEX2 <= STOP) DO
            C := BUF[INDEX2];
	        IF C=BYTE#60 THEN (* '<' TagBegin *)

              INDEX2 := INDEX2 + 1; (* geht bei PCWORX leider nicht anders !*)
              C := BUF[INDEX2];
              INDEX2 := INDEX2 - 1;
              IF C=BYTE#47 THEN (* TagTerm '/' *)
                EMPTY_TAG := TRUE;
                MODE := 200; (* TEXT Element *)
              ELSE
   		        MODE := 100; (* Element *)
              END_IF;
              CTRL.TYP := 1; (* struktur-element *)
              EXIT;
            ELSIF C>BYTE#32  THEN (* Printable-Character *)
              CTRL.TYP := 1;      (* element with text *)
              MODE := 200;
              EXIT;
            END_IF;
            INDEX2 := INDEX2 + 1;
          END_WHILE;
        END_IF;
        INDEX := INDEX + 1;
      END_WHILE;
    END_IF;

    (* Neues Element gefunden*)
    IF CTRL.TYP > 0 THEN

      (* Sonderprüfung auf Processing Instruction (PI) *)
      IF BUF[s1]=BYTE#63 THEN (* '?' for Processing Instruction *)
        s1 := s1+1; (* führendes '?' auslassen *)
        CTRL.TYP := 5;
      END_IF;
      CTRL.BLOCK1_START := INT_TO_UINT(S1);
      CTRL.BLOCK1_STOP  := INT_TO_UINT(E1);
      BUFFER_TO_STRING(size:=INT_TO_UINT(STOP+1),start:=CTRL.BLOCK1_START,stop:=CTRL.BLOCK1_STOP,pt:=BUF);
      CTRL.ELEMENT:=BUFFER_TO_STRING.BUFFER_TO_STRING;
      BUF:=BUFFER_TO_STRING.pt;

      CTRL.COUNT := CTRL.COUNT + UINT#1;
      CTRL.LEVEL := CTRL.LEVEL + UINT#1; 

	  IF PATH_OVERFLOW = FALSE THEN
        (* Stringlänge überwachen *)
        IF LEN(CTRL.PATH) + LEN(CTRL.ELEMENT) + 1 > 255 THEN
          PATH_OVERFLOW := TRUE;
          CTRL.PATH := 'OVERFLOW';
        ELSE
          CTRL.PATH  := CONCAT(CTRL.PATH,'/');
          CTRL.PATH  := CONCAT(CTRL.PATH,CTRL.ELEMENT);
        END_IF;      
      END_IF;      

      IF BIT_OF_DWORD(WORD_TO_DWORD(COMMAND),CTRL.TYP) THEN
        (*####################  DEBUG-MESSAGE  ###################################*)
        (*IF _debug_enable THEN
          LOG_CL.NEW_MSG := 'EL: #T:~1 #C:~2 #E:~3 #P:~6 #L:~7';
          LOG_CL.PRINTF[1] := INT_TO_STRING(CTRL.TYP,'%d');
          LOG_CL.PRINTF[2] := UINT_TO_STRING(CTRL.COUNT,'%u');
          LOG_CL.PRINTF[3] := CTRL.ELEMENT;
          LOG_CL.PRINTF[6] := CTRL.PATH;
          LOG_CL.PRINTF[7] := UINT_TO_STRING(CTRL.LEVEL,'%u');
          LOG_MSG();
        END_IF;*)
        (*########################################################################*)
        RETURN;
      END_IF; 
    END_IF; 

  200: (* ---------- TEXT SECTION ------------------ *)
    CTRL.VALUE := '';
    IF EMPTY_TAG = FALSE THEN
      s1 := INDEX;
      (* suche '<' EndTag*)
      WHILE (INDEX <= STOP) AND (BUF[INDEX]<>BYTE#60) DO
        INDEX := INDEX + 1;
      END_WHILE;

      E1 := INDEX-1;
      CTRL.BLOCK1_START := INT_TO_UINT(S1);
      CTRL.BLOCK1_STOP  := INT_TO_UINT(E1);

      BUFFER_TO_STRING(size:=INT_TO_UINT(STOP+1),start:=CTRL.BLOCK1_START,stop:=CTRL.BLOCK1_STOP,pt:=BUF);
      CTRL.VALUE:=BUFFER_TO_STRING.BUFFER_TO_STRING;
      BUF:=BUFFER_TO_STRING.pt;
    END_IF;

    EMPTY_TAG := FALSE;
    MODE := 300; (* -> NEXT-JOB: END ELEMENT *)
    CTRL.COUNT := CTRL.COUNT + UINT#1;
    CTRL.TYP := 3;

    IF BIT_OF_DWORD(WORD_TO_DWORD(COMMAND),CTRL.TYP) THEN
      (*####################  DEBUG-MESSAGE  ###################################*)
      (*IF _debug_enable THEN
        LOG_CL.NEW_MSG := 'TE: #T:~1 #C:~2 #E:~3 #V:~4 #P:~6 #L:~7';
        LOG_CL.PRINTF[1] := INT_TO_STRING(CTRL.TYP,'%d');
        LOG_CL.PRINTF[2] := UINT_TO_STRING(CTRL.COUNT,'%u');
        LOG_CL.PRINTF[3] := CTRL.ELEMENT;
        LOG_CL.PRINTF[4] := CTRL.VALUE;
        LOG_CL.PRINTF[6] := CTRL.PATH;
        LOG_CL.PRINTF[7] := UINT_TO_STRING(CTRL.LEVEL,'%u');
        LOG_MSG();
      END_IF;*)
      (*########################################################################*)
      RETURN;
    END_IF;

  300: (* ---------- END ELEMENT SECTION ------------------ *)

    WHILE (INDEX <= STOP) DO
	  C := BUF[INDEX];
      IF C=BYTE#62 THEN (* '>' TagEnd *)
        INDEX := INDEX + 1;
        FINDB(str1:=CTRL.PATH,str2:='/');
		S1 := FINDB.FindB;

	    IF PATH_OVERFLOW = FALSE THEN
          IF S1>1 THEN
            CTRL.ELEMENT := RIGHT(CTRL.PATH,LEN(CTRL.PATH)-S1);
            CTRL.PATH := LEFT(CTRL.PATH,S1-1);
          ELSE
            CTRL.ELEMENT := RIGHT(CTRL.PATH,LEN(CTRL.PATH)-1);
            CTRL.PATH :='';
          END_IF;
        END_IF;

        CTRL.LEVEL := CTRL.LEVEL - UINT#1; 
        CTRL.COUNT := CTRL.COUNT + UINT#1;
        CTRL.TYP := 2; 
        MODE := 100; 

        IF BIT_OF_DWORD(WORD_TO_DWORD(COMMAND),CTRL.TYP) THEN
          (*####################  DEBUG-MESSAGE  ###################################*)
          (*IF _debug_enable THEN
            LOG_CL.NEW_MSG := 'CE: #T:~1 #C:~2 #E:~3 #P:~6 #L:~7';
            LOG_CL.PRINTF[1] := INT_TO_STRING(CTRL.TYP,'%d');
            LOG_CL.PRINTF[2] := UINT_TO_STRING(CTRL.COUNT,'%u');
            LOG_CL.PRINTF[3] := CTRL.ELEMENT;
            LOG_CL.PRINTF[6] := CTRL.PATH;
            LOG_CL.PRINTF[7] := UINT_TO_STRING(CTRL.LEVEL,'%u');
            LOG_MSG();
          END_IF;*)
          (*########################################################################*)
		  RETURN;
        ELSE
		  EXIT;
        END_IF;
      END_IF;
      INDEX := INDEX + 1;
    END_WHILE;

  400:  (* ---------- ATTRIBUTE SECTION ------------------ *)
    (* search first normal charakter *)
    WHILE (INDEX <= STOP AND BUF[INDEX]<=BYTE#32) DO
      INDEX := INDEX + 1;
    END_WHILE;

    (* begin Attribe name *)
    E1 := 0;
    S1 := INDEX;
    (* search end of Attrib Name '=' *)
    WHILE (INDEX <= STOP) DO
      IF BUF[INDEX]=BYTE#61 THEN (* '=' Equals *)
	    E1 := INDEX-1;
	    EXIT;
	  END_IF;
      INDEX := INDEX + 1;
    END_WHILE;
               
    IF E1>0 THEN
      (* Attribute Name *)
      CTRL.BLOCK1_START := INT_TO_UINT(S1);
      CTRL.BLOCK1_STOP  := INT_TO_UINT(E1);
      BUFFER_TO_STRING(size:=INT_TO_UINT(STOP+1),start:=CTRL.BLOCK1_START,stop:=CTRL.BLOCK1_STOP,pt:=BUF);
      CTRL.ATTRIBUTE:=BUFFER_TO_STRING.BUFFER_TO_STRING;
      BUF:=BUFFER_TO_STRING.pt;

      (* search end of Attrib Value '=' *)
      INDEX := INDEX + 2;
      E1 := 0;
      S1 := INDEX;
      WHILE (INDEX <= STOP AND E1=0) DO
	    C := BUF[INDEX];
        IF C=BYTE#34 OR C=BYTE#39 THEN (* " OR ' Equals *)
	      E1 := INDEX-1;
	    END_IF;
        INDEX := INDEX + 1;
      END_WHILE;

      IF E1>0 THEN
        (* Value *)
        CTRL.BLOCK2_START := INT_TO_UINT(S1);
        CTRL.BLOCK2_STOP  := INT_TO_UINT(E1);

		(* bei leeren "" ist start groesser als stop und wird somit zum leerstring *)
	    BUFFER_TO_STRING(size:=INT_TO_UINT(STOP+1),start:=CTRL.BLOCK2_START,stop:=CTRL.BLOCK2_STOP,pt:=BUF);
        CTRL.VALUE:=BUFFER_TO_STRING.BUFFER_TO_STRING;
        BUF:=BUFFER_TO_STRING.pt;

        (* search next non white space charakter *)
        WHILE (INDEX <= STOP AND BUF[INDEX]<=BYTE#32) DO
          INDEX := INDEX + 1;
        END_WHILE;

        C := BUF[INDEX];
        (* TagEnd '>' *)
        IF C=BYTE#62 THEN
          INDEX := INDEX + 1;
          INDEX2 := INDEX;

          (* search next non white space charakter *)
          WHILE (INDEX <= STOP AND BUF[INDEX]<=BYTE#32) DO
            INDEX := INDEX + 1;
          END_WHILE;

          IF BUF[INDEX]=BYTE#60 THEN (* TagBegin '<' *)
            MODE := 100; (* -> NEXT-JOB: ELEMENT-SECTION *)
          ELSE
            INDEX := INDEX2;
            MODE := 200; (* -> NEXT-JOB: TEXT-SECTION *)
          END_IF;

        ELSIF C=BYTE#47 OR C=BYTE#63 THEN (* TagTerm '/' OR '?' end Processing Instruction *)
          MODE := 300; (* -> NEXT-JOB: END ELEMENT *)
        ELSE
          MODE := 400; (* -> NEXT-JOB: ATTRIBUTE-SECTION *)
        END_IF;

        CTRL.COUNT := CTRL.COUNT + UINT#1;
        CTRL.TYP := 4;
        IF BIT_OF_DWORD(WORD_TO_DWORD(COMMAND),CTRL.TYP) THEN
          (*####################  DEBUG-MESSAGE  ###################################*)
          (*IF _debug_enable THEN
            LOG_CL.NEW_MSG := 'AT: #T:~1 #C:~2 #E:~3 #A:~4 #V:~5 #P:~6 #L:~7';
            LOG_CL.PRINTF[1] := INT_TO_STRING(CTRL.TYP,'%d');
            LOG_CL.PRINTF[2] := UINT_TO_STRING(CTRL.COUNT,'%u');
            LOG_CL.PRINTF[3] := CTRL.ELEMENT;
            LOG_CL.PRINTF[4] := CTRL.ATTRIBUTE;
            LOG_CL.PRINTF[5] := CTRL.VALUE;
            LOG_CL.PRINTF[6] := CTRL.PATH;
            LOG_CL.PRINTF[7] := UINT_TO_STRING(CTRL.LEVEL,'%u');
            LOG_MSG();
          END_IF;*)
          (*########################################################################*)
          RETURN;
        END_IF;
      END_IF;
    END_IF;

  500: (* ---------- SPECIAL DATA SECTION (Document Type Declarations) ---------- *)

    CTRL.TYP := 0;
    S1 := 0;
    INDEX2 := 11;

    WHILE (S1=0) DO
      INDEX2 := INDEX2 + 1;
      CTRL.TYP := INDEX2;

      CASE INDEX2 OF 
      12: (* CDATA *)
	    S_CODE := '[CDATA[';
	    E_CODE := ']]>';
      13: (* COMMENT *)
	    S_CODE := '--';
	    E_CODE := '-->';
      14: (* ANY DTD *)
	    E_CODE := '';
        S1 := INDEX;
        EXIT;       
      END_CASE;

      E1 := LEN(S_CODE);
      BUFFER_SEARCH(size:=INT_TO_UINT(INDEX+E1),str:=S_CODE,pos:=INDEX,ign:=FALSE,pt:=BUF);
      BUF:=BUFFER_SEARCH.pt;
      IF BUFFER_SEARCH.BUFFER_SEARCH = INDEX THEN
        S1 := INDEX+E1;
      END_IF;
    END_WHILE;

    CTRL.BLOCK1_START := INT_TO_UINT(S1);
    IF LEN(E_CODE)>0 THEN
      (* Ende Kennung suchen *)
      BUFFER_SEARCH(size:=INT_TO_UINT(STOP+1),str:=E_CODE,pos:=INDEX,ign:=FALSE,pt:=BUF);
      BUF:=BUFFER_SEARCH.pt;

      E1 := BUFFER_SEARCH.BUFFER_SEARCH;
      CTRL.BLOCK1_STOP := INT_TO_UINT(E1-1);
      INDEX := E1+LEN(E_CODE); (* naechstes element *)
    ELSE

      (* suche '>' EndTag*)
      INDEX2 := 1; (* <> Paar zähler *)
      WHILE (INDEX <= STOP AND INDEX2>0) DO
	    C := BUF[INDEX];

        IF C=BYTE#60 THEN    (* '<' TagBegin *)
		  INDEX2 := INDEX2+1;     
        ELSIF C=BYTE#62 THEN (* '>' TagEnd   *)
		  INDEX2 := INDEX2-1;     
        ELSIF C=BYTE#34 OR C=BYTE#39 THEN (* " Double Quote OR ' Single Quote *)
          INDEX := INDEX + 1;
          WHILE (INDEX <= STOP) DO
   	        C := BUF[INDEX];
            IF C=BYTE#34 OR C=BYTE#39 THEN (* " Double Quote OR ' Single Quote *)
              EXIT;
			END_IF;       
            INDEX := INDEX + 1;
          END_WHILE;
		END_IF;       
        INDEX := INDEX + 1;
      END_WHILE;

      CTRL.BLOCK1_STOP := INT_TO_UINT(INDEX-2);

    END_IF;

    BUFFER_TO_STRING(size:=INT_TO_UINT(STOP+1),start:=CTRL.BLOCK1_START,stop:=CTRL.BLOCK1_STOP,pt:=BUF);
    CTRL.VALUE:=BUFFER_TO_STRING.BUFFER_TO_STRING;
    BUF:=BUFFER_TO_STRING.pt;

    CTRL.COUNT := CTRL.COUNT + UINT#1;
    MODE := 100; (* -> NEXT-JOB: ELEMENT *)

	IF BIT_OF_DWORD(WORD_TO_DWORD(COMMAND),CTRL.TYP) THEN
      (*####################  DEBUG-MESSAGE  ###################################*)
      (*IF _debug_enable THEN
        LOG_CL.NEW_MSG := 'DTD: #T:~1 #C:~2 #S:~3 #E:~4 #V:~5 #P:~6 #L:~7';
        LOG_CL.PRINTF[1] := INT_TO_STRING(CTRL.TYP,'%d');
        LOG_CL.PRINTF[2] := UINT_TO_STRING(CTRL.COUNT,'%u');
        LOG_CL.PRINTF[3] := UINT_TO_STRING(CTRL.BLOCK1_START,'%u');
        LOG_CL.PRINTF[4] := UINT_TO_STRING(CTRL.BLOCK1_STOP,'%u');
        LOG_CL.PRINTF[5] := CTRL.VALUE;
        LOG_CL.PRINTF[6] := CTRL.PATH;
        LOG_CL.PRINTF[7] := UINT_TO_STRING(CTRL.LEVEL,'%u');
        LOG_MSG();
      END_IF;*)
      (*########################################################################*)
      RETURN;
    END_IF;

  END_CASE;
END_WHILE;


(* revision history
ks	18. oct. 2008	rev 1.0
	original version

ks	20. oct. 2009	rev 1.1
	Networkbuffer und Buffer-funktionen auf Basis 0

ks	10. mai. 2010	rev 1.2
	stringlänge maximal 250 zeichen

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
