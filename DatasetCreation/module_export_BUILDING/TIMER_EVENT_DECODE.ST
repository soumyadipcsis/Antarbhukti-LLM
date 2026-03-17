(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.1	25. oct. 2008
programmer 	hugo
tested by	oscat

STRING_TO_TIMER_EVENT converts a string to a timer event structure.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TIMER_EVENT_DECODE

(*Group:Default*)


VAR_INPUT
	EVENT :	oscat_STRING250;
	LANG :	INT;
END_VAR


VAR_OUTPUT
	TIMER_EVENT_DECODE :	oscat_TIMER_EVENT_DATA;
END_VAR


VAR
	pos :	INT;
	start :	INT;
	stop :	INT;
	step :	INT;
	tmp :	oscat_STRING60;
	char :	INT;
	FSTRING_TO_BYTE :	FSTRING_TO_BYTE;
	IS_CC :	IS_CC;
	FSTRING_TO_WEEK :	FSTRING_TO_WEEK;
	FSTRING_TO_WEEKDAY :	FSTRING_TO_WEEKDAY;
	STRING_TO_TOD :	STRING_TO_TOD;
	_STRING_TO_TIME :	_STRING_TO_TIME;
END_VAR


(*@KEY@: WORKSHEET
NAME: TIMER_EVENT_DECODE
IEC_LANGUAGE: ST
*)
(* a timer event is specified as follows:
	$typ;ch;day;start;duration;land;lor#
$ 		= start of definition
typ 	= type of definition	(number)
channel	= channel number		(number)
day 	= day number			(number)
start	= start time			(time of day)
duration= duration of event		(time)
land	= mask for output AND	(8bit value)
lor		= mask for ourput OR	(8bit value)
#		= end of definition
*)

(* check for start and ending character *)
stop := LEN(event);
IF (GET_CHAR(event,1) <> 60) AND (GET_CHAR(event,stop) <> 62) THEN RETURN; END_IF;
start := 2;
step := 0;

(* parse the string for next ; *)
FOR pos := 2 TO stop DO
    char := GET_CHAR(event,pos);

	IF char = 59 OR char = 62 THEN
		tmp := MID(event, pos - start, start);
		CASE step OF
			0:	(* read type *)
                FSTRING_TO_BYTE(IN:=tmp);
                TIMER_EVENT_DECODE.typ := FSTRING_TO_BYTE.FSTRING_TO_BYTE;

			1:	(* read channel *)
                FSTRING_TO_BYTE(IN:=tmp);
                TIMER_EVENT_DECODE.channel := FSTRING_TO_BYTE.FSTRING_TO_BYTE;

			2:	(* read day *)
                IS_CC(str:=tmp,cmp:='0123456789abcdefABCDEF#');

				IF IS_CC.IS_CC THEN
                    FSTRING_TO_BYTE(IN:=tmp);
                    TIMER_EVENT_DECODE.DAY := FSTRING_TO_BYTE.FSTRING_TO_BYTE;
				ELSIF TIMER_EVENT_DECODE.typ = BYTE#2 THEN
                    FSTRING_TO_WEEK(WEEK:=tmp,LANG:=LANG);
                    TIMER_EVENT_DECODE.DAY := FSTRING_TO_WEEK.FSTRING_TO_WEEK;
				ELSE
                    FSTRING_TO_WEEKDAY(WDAY:=tmp,LANG:=LANG);
                    TIMER_EVENT_DECODE.DAY := INT_TO_BYTE(FSTRING_TO_WEEKDAY.FSTRING_TO_WEEKDAY);
				END_IF;

			3:	(* read start *)
			    STRING_TO_TOD(_TOD:=tmp);
                TIMER_EVENT_DECODE.start := STRING_TO_TOD.STRING_TO_TOD;

			4:	(* read duaration *)
                _STRING_TO_TIME(_TIME:=tmp);
                TIMER_EVENT_DECODE.duration := _STRING_TO_TIME.STRING_TO_TIME;

			5:	(* read land *)
                FSTRING_TO_BYTE(IN:=tmp);
				TIMER_EVENT_DECODE.land := FSTRING_TO_BYTE.FSTRING_TO_BYTE;

			6:	(* read lor *)
                FSTRING_TO_BYTE(IN:=tmp);
				TIMER_EVENT_DECODE.LOR := FSTRING_TO_BYTE.FSTRING_TO_BYTE;
		END_CASE;
		start := pos + 1;
		step := step + 1;
	END_IF;
END_FOR;


(* revision history
hm	17. jun 2008	rev 1.0
	original version

hm	25. oct. 2008	rev 1.1
	adding input lang for language selection
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
