(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: JALOUSIE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	12. nov. 2009
programmer 	heinz
tested by	oscat
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BLIND_SHADE_S

(*Group:Default*)


VAR_INPUT
	UP :	BOOL;
	DN :	BOOL;
	S_IN :	BYTE;
	PI :	BYTE;
	ENABLE :	BOOL;
	SUN :	BOOL;
	HORZ1 :	REAL := 100.0;
	HORZ2 :	REAL := 260.0;
	VERT :	REAL := 90.0;
	ALERT :	BOOL;
	SUNRISE_OFFSET :	TIME := T#1h;
	SUNSET_PRESET :	TIME := T#1h;
	SHADE_DELAY :	TIME := T#60s;
	SHADE_POS :	BYTE;
	QU :	BOOL;
	QD :	BOOL;
	STATUS :	BYTE;
	PO :	BYTE;
END_VAR


VAR_IN_OUT
	CX :	oscat_CALENDAR;
END_VAR


(*@KEY@: WORKSHEET
NAME: BLIND_SHADE_S
IEC_LANGUAGE: ST
*)
(* status definition
   151 = shadow               move shutter down for shadowing
   152 = alert                  move shutter up by setting QU:=TRUE when door is open.
*)

(* the input sun is sent through tof which will delay the shade for the time shade_delay *)
sun_delay(IN := sun, PT := shade_delay);

IF ALERT THEN
   QU := TRUE;
   QD := FALSE;
   STATUS := BYTE#152;
ELSIF UP AND DN AND ENABLE AND sun_delay.Q
AND (CX.SUN_HOR > HORZ1) AND (CX.SUN_HOR < HORZ2)
AND (CX.SUN_VER < VERT)
AND (DT_TO_TOD(CX.UTC) > CX.SUN_RISE + sunrise_offset) AND (DT_TO_TOD(CX.UTC) < CX.SUN_SET - sunset_preset) THEN
   QU := UP;
   QD := DN;
   STATUS := BYTE#151;
   (* Calculate Position, must be shade_pos or less *)
   PO := MIN(PI, shade_pos);
ELSE
   QU := UP;
   QD := DN;
   PO := PI;
   STATUS := S_IN;
END_IF;

(* revision history
hf	12 nov. 2009	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
