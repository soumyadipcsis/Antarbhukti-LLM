(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: JALOUSIE
*)
(*@KEY@:DESCRIPTION*)
version 1.4	13. mar. 2009
programmer 	hugo
tested by	tobias
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BLIND_SHADE

(*Group:Default*)


VAR_INPUT
	UP :	BOOL;
	DN :	BOOL;
	S_IN :	BYTE;
	PI :	BYTE;
	AI :	BYTE;
	ENABLE :	BOOL;
	SUN :	BOOL;
	SUNRISE_OFFSET :	TIME := T#1h;
	SUNSET_PRESET :	TIME := T#1h;
	DIRECTION :	REAL := 180.0;
	ANGLE_OFFSET :	REAL := 80.0;
	SLAT_WIDTH :	REAL := 80.0;
	SLAT_SPACING :	REAL := 60.0;
	SHADE_DELAY :	TIME := T#60s;
	SHADE_POS :	BYTE;
END_VAR


VAR_OUTPUT
	QU :	BOOL;
	QD :	BOOL;
	STATUS :	BYTE;
	PO :	BYTE;
	AO :	BYTE;
END_VAR


VAR_IN_OUT
	CX :	oscat_CALENDAR;
END_VAR


VAR
	angle :	REAL;
	sun_delay :	TOF;
END_VAR


(*@KEY@: WORKSHEET
NAME: BLIND_SHADE
IEC_LANGUAGE: ST
*)
(* the input sun is sent through tof which will delay the shade for the time shade_delay *)
sun_delay(IN := sun, PT := shade_delay);

IF UP AND DN AND enable AND sun_delay.Q AND cx.SUN_HOR > direction - angle_offset AND cx.SUN_HOR < direction + angle_offset AND
	DT_TO_TOD(cx.UTC) > cx.SUN_RISE + TIME_TO_UDINT(sunrise_offset) AND DT_TO_TOD(cx.UTC) < cx.SUN_SET - TIME_TO_UDINT(sunset_preset) THEN
	status := BYTE#151;
	QU := UP;
	QD := DN;
	(* position is predefined *)
	po := shade_pos;
	(* shading is active now calculate the slat angle *)
	(* calculate the max angle for the blind *)
	angle := DEG(ATAN(slat_spacing / slat_width));
	(* check if sun angle is between 0 and max angle *)
	IF cx.SUN_VER > 0.0 AND cx.SUN_VER < angle THEN
		angle := cx.SUN_VER + DEG(ACOS(COS(RAD(cx.SUN_VER))*slat_spacing / Slat_width));
		ao := INT_TO_BYTE(LIMIT(0,UDINT_TO_INT(TRUNC_UDINT(angle * 2.833333333)), 255));
	ELSE
		ao := BYTE#255;
	END_IF;
ELSE
	QU := UP;
	QD := DN;
	po := pi;
	ao := ai;
	status := S_IN;
END_IF;

(* revision history
hm	15 oct. 2007	rev 1.0
	original version

hm	19. oct 2007	rev 1.1
	manual mode was not detected because outputs were checked and not inputs UP and DN

hm	24. nov 2007	rev 1.2
	added shade_delay to avoid constant up and down if sun is out parcially

hm	8. feb 2009	rev 1.3
	added shading position shade_pos to be configured
	changed inputs to utilize calendar data structure

hm	13. mar. 2009	rev 1.4
	improved code

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
