(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	19. oct. 2008
programmer 	hugo
tested by	oscat

DT_TO_STRINGF converts a DATETIME input to a formatted string
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DT_TO_STRF

(*Group:NewGroup*)


VAR_INPUT
	DTI :	UDINT;
	MS :	INT;
	FMT :	STRING;
	LANG :	INT;
END_VAR


VAR_OUTPUT
	DT_TO_STRF :	STRING;
END_VAR


VAR
	FILL :	oscat_STRING1 := STRING#'0';
	BLANK :	oscat_STRING1 := STRING#' ';
	ly :	INT;
	dx :	UDINT;
	fs :	oscat_STRING10;
	fs_tmp :	oscat_STRING10;
	td :	UDINT;
	tmp :	INT;
	pos :	INT;
	f :	INT;
	CODE :	CODE;
	MONTH_TO_STRING :	MONTH_TO_STRING;
	WEEKDAY_TO_STRING :	WEEKDAY_TO_STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: DT_TO_STRF
IEC_LANGUAGE: ST
*)
IF LANG < 1 THEN ly := 1; ELSE ly := MIN(2, LANG); END_IF;

(* decode date and time information *)
dx := DT_TO_DATE(DTI);
td := DT_TO_TOD(DTI);

(* parse the format string *)
DT_TO_STRF := FMT;
pos := FIND(DT_TO_STRF, '#');
WHILE pos > 0 DO
	(* retrieve format identifier *)
    CODE(STR:=DT_TO_STRF,POS:=pos + 1);
    f := _BYTE_TO_INT(CODE.CODE);
	(* generate the return string according to the format character *)
	fs := '';
	CASE f OF
         0: RETURN; (* illegal character index *)
 
		65 : (* letter A retunrs the year in 4 digits *)
			fs := INT_TO_STRING(YEAR_OF_DATE(dx),'%d');
		66 : (* letter B returns the year in exactly 2 digits *)
			fs := RIGHT(INT_TO_STRING(YEAR_OF_DATE(dx),'%02d'),2);
		67 : (* letter C returns the month with 1 or 2 digits *)
			fs := INT_TO_STRING(MONTH_OF_DATE(dx),'%d');
		68 : (* letter D returns the month with exactly 2 digits *)
			fs := INT_TO_STRING(MONTH_OF_DATE(dx),'%02d');
		69 : (* letter E returns the month with 3 characters *)
            MONTH_TO_STRING(MTH:=MONTH_OF_DATE(dx),LANG:=ly,LX:=3);
            fs:=MONTH_TO_STRING.MONTH_TO_STRING;
		70 : (* letter F returns the month with all characters *)
            MONTH_TO_STRING(MTH:=MONTH_OF_DATE(dx),LANG:=ly,LX:=0);
            fs:=MONTH_TO_STRING.MONTH_TO_STRING;
		71 : (* letter G returns the day with up to 2 digits *)
			fs := INT_TO_STRING(DAY_OF_MONTH(dx),'%d');
		72 : (* letter H returns the day of the month with exactly 2 digits *)
			fs := INT_TO_STRING(DAY_OF_MONTH(dx),'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
		73 : (* letter I returns the weekday as the number 1..7 1 = monday *)
			fs := INT_TO_STRING(DAY_OF_WEEK(dx),'%d');
		74 : (* letter J returns the weekday in 2 character writing *)
            WEEKDAY_TO_STRING(WDAY:=DAY_OF_WEEK(dx),LANG:=ly,LX:=2);
            fs := WEEKDAY_TO_STRING.WEEKDAY_TO_STRING;
		75 : (* letter K returns the weekday with all characters *)
            WEEKDAY_TO_STRING(WDAY:=DAY_OF_WEEK(dx),LANG:=ly,LX:=0);
            fs := WEEKDAY_TO_STRING.WEEKDAY_TO_STRING;
		76 : (* letter L returns AM or PM for the given DateTime *)
			IF td >= UDINT#43200000 THEN fs := 'PM'; ELSE fs := 'AM'; END_IF;
		77 : (* letter M returns the hour in 1 or 2 digit form 0..24h *)
			fs := INT_TO_STRING(HOUR(td),'%d');
		78 : (* letter N returns the hour in exactly 2 digit form 0..24h *)
			fs := INT_TO_STRING(HOUR(td),'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
		79 : (* letter O returns the hour in 1 or 2 digit form 0..12h *)
			tmp := HOUR(td) MOD 12;
			IF tmp = 0 THEN tmp := 12; END_IF;
			fs := INT_TO_STRING(tmp,'%d');
		80 : (* letter P returns the hour in exactly 2 digit form 0..12h *)
			tmp := HOUR(td) MOD 12;
			IF tmp = 0 THEN tmp := 12; END_IF;
			fs := INT_TO_STRING(tmp,'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
		81 : (* letter Q returns the minute of the hour in 1 or two digit form *)
			fs := INT_TO_STRING(MINUTE(td),'%d');
		82 : (* letter R returns the minute of the hour in exactly two digit form *)
			fs := INT_TO_STRING(MINUTE(td),'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
		83 : (* letter S returns the second of the minute in 1 or two digit form *)
			fs := INT_TO_STRING(REAL_TO_INT(SECOND(td)),'%d');
		84 : (* letter T returns the second of the minute in exactly two digit form *)
			fs := INT_TO_STRING(REAL_TO_INT(SECOND(td)),'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
		85 : (* letter U returns the milliseconds in 1 to 3 digits *)
			fs := INT_TO_STRING(MS,'%d');
		86 : (* letter V returns the milliseconds in exactly 3 digit form *)
			fs := INT_TO_STRING(MS,'%03d');
		87 : (* letter W returns the day of the month with exactly 2 digits first digit is filled with blank if necessary *)
			fs := INT_TO_STRING(DAY_OF_MONTH(dx),'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(BLANK, fs_tmp); END_IF;
		88 : (* letter X returns the month with exactly 2 digits first digit is filled with blank if necessary *)
			fs := INT_TO_STRING(MONTH_OF_DATE(dx),'%d');
			IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(BLANK, fs_tmp); END_IF;
	END_CASE;
	DT_TO_STRF := REPLACE(DT_TO_STRF, fs, 2, pos);
	pos := FIND(DT_TO_STRF, '#');
END_WHILE;

(* revision history
hm	7. oct. 2008	rev 1.0
	original version

hm	19. oct. 2008	rev 1.1
	changed language setup constants
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
