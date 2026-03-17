(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: NETWORK
*)
(*@KEY@:DESCRIPTION*)
(*

version 1.0	14. aug. 2009
programmer 	ks
tested by	ks

PRINTF erzeugt aus einem Parameterstring und den übergebenen Parameterdaten einen Text
*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PRINT_SF

(*Group:Variablen*)


VAR
	pos :	INT;
	c :	INT;
	src :	oscat_STRING1 := '~';
	run :	BOOL;
	CODE :	CODE_250;
END_VAR


(*Group:in_out*)


VAR_IN_OUT
	PRINTF_DATA :	PRINTF_DATA_250;
	STR :	oscat_STRING250;
END_VAR


(*Group:System*)


VAR_EXTERNAL
	PLC_SYS_TICK_CNT :	DINT;
	RTC_HOURS :	INT;
	RTC_MINUTES :	INT;
	RTC_SECONDS :	INT;
	RTC_DAY :	INT;
	RTC_MONTH :	INT;
	RTC_YEAR :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: PRINT_SF
IEC_LANGUAGE: ST
*)
IF LEN(STR) > 0 THEN
  run := TRUE;

  WHILE (run) DO        
    pos := FIND(STR,src);
    PRINTF_DATA[10] := '';

    IF pos = 0 THEN
		run:= FALSE;
    ELSE
      CODE(STR:=STR,POS:=pos + 1);
      c:= _BYTE_TO_INT(CODE.CODE);

      IF ISC_NUM(INT_TO_BYTE(c)) THEN
	    c := c - 48; (* notwendig weil innerhalb einer indexangabe nur eine var stehen darf *)
	    PRINTF_DATA[10] := PRINTF_DATA[c]; (* Kommando 1-9 ergibt Parameterindex 1-9 *)

	  ELSIF c = 68 THEN (* pruefe auf 'D' *)
        (* erzeugt Datum-String z.B. 2008.11.12 *)
	    PRINTF_DATA[10] := CONCAT(INT_TO_STRING(RTC_DAY,'%02d'),'.'); 	
	    PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],INT_TO_STRING(RTC_MONTH,'%02d')); 	
	    PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],STRING#'.'); 	
	    PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],INT_TO_STRING(RTC_YEAR,'%02d')); 	

	  ELSIF c = 83 OR c = 84 THEN (* pruefe auf 'S' oder 'T' *)
	    PRINTF_DATA[10] := CONCAT(INT_TO_STRING(RTC_HOURS ,'%02d'),':'); 	
	    PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],INT_TO_STRING(RTC_MINUTES,'%02d')); 	
	    PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],':'); 	
	    PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],INT_TO_STRING(RTC_SECONDS,'%02d')); 	

        IF c = 83 THEN (* pruefe auf 'S' *)
	      PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],':'); 	
	      PRINTF_DATA[10] := CONCAT(PRINTF_DATA[10],DINT_TO_STRING(PLC_SYS_TICK_CNT MOD DINT#1000,'%03d')); 	
		END_IF;
      END_IF;
	  (* Parameter gegen Text tauschen *)
      IF LEN(PRINTF_DATA[10]) + LEN(STR) > 250 THEN
        PRINTF_DATA[10] := '..';
      END_IF; 
      (* pcworx: aus und eingangsstring muss verschieden sein *)
      PRINTF_DATA[11] := STR;
      STR := REPLACE(PRINTF_DATA[11],PRINTF_DATA[10],2,pos);
	END_IF;  
  END_WHILE;
END_IF;

(* revision history

ks	14. aug. 2009	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
