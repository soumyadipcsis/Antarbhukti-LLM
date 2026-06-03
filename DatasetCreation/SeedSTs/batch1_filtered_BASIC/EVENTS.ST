(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	18. jan. 2010
programmer 	hugo
tested by	tobias

event checks an array with a list of events and displays the event if today is one.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK EVENTS

(*Group:Default*)


VAR_INPUT
	DATE_IN :	UDINT;
	ENA :	BOOL;
END_VAR


VAR_OUTPUT
	Y :	BOOL;
	NAME :	oscat_STRING30;
END_VAR


VAR_IN_OUT
	ELIST :	oscat_HOLIDAY_DATA_0_49;
END_VAR


VAR
	i :	INT;
	last_active :	UDINT;
	size :	INT := 49;
	day_in :	DINT;
	cyr :	INT;
	lday :	DINT;
	check :	oscat_HOLIDAY_DATA;
	y_int :	BOOL;
	name_int :	oscat_STRING30;
END_VAR


(*@KEY@: WORKSHEET
NAME: EVENTS
IEC_LANGUAGE: ST
*)
(* for performance reasons only activate once a day *)
IF last_active <> date_in THEN
	last_active := DATE_IN;
	Y_int := FALSE;
	name_int := '';
	day_in := DAY_OF_DATE(DATE_IN);
	cyr := YEAR_OF_DATE(DATE_IN);

	(* search list for events *)
	FOR i := 0 TO size DO
		check := elist[i];
		lday := DAY_OF_DATE(SET_DATE(cyr,SINT_TO_INT(check.month), SINT_TO_INT(check.day)));
		IF day_in >= lday AND day_in <= lday + SINT_TO_DINT(check.use) - DINT#1 THEN
			y_int := TRUE;
			name_int := check.name;
			EXIT;
		END_IF;
	END_FOR;
END_IF;

IF ENA THEN
	Y := y_int;
	NAME := name_int;
ELSE
	Y := FALSE;
	NAME := '';
END_IF;

(* revision history
hm  18. jan. 2011	rev 1.0
	new module

*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
