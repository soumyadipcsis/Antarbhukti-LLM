(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: WEATHER
*)
(*@KEY@:DESCRIPTION*)
version 1.0		04. may. 2011
programmer 		ks
tested by		ks

WORLD_WEATHER_ICON_OSCAT ändert die ICON Nummer auf den OSCAT-Standard um
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK WORLD_WEATHER_ICON_OSCAT

(*Group:Default*)


VAR_INPUT
	ACTIVATE :	BOOL;
END_VAR


VAR_IN_OUT
	WW :	oscat_WORLD_WEATHER_DATA;
END_VAR


VAR
	act_last :	BOOL;
	x :	INT;
	i :	INT;
	init :	BOOL;
	dat :	oscat_WORLD_WEATHER_aI0_41;
END_VAR


(*@KEY@: WORKSHEET
NAME: init
IEC_LANGUAGE: ST
*)
IF not init THEN
    init := TRUE;

	dat[00] := 0;
	dat[01] := 14;
	dat[02] := 12;
	dat[03] := 9;
	dat[04] := 9;
	dat[05] := 0;
	dat[06] := 7;
	dat[07] := 7;
	dat[08] := 0;
	dat[09] := 2;
	dat[10] := 2;
	dat[11] := 3;
	dat[12] := 3;
	dat[13] := 1;
	dat[14] := 0;
	dat[15] := 0;
	dat[16] := 17;
	dat[17] := 4;
	dat[18] := 4;
	dat[19] := 3;
	dat[20] := 3;
	dat[21] := 1;
	dat[22] := 0;
	dat[23] := 0;
	dat[24] := 17;
	dat[25] := 2;
	dat[26] := 2;
	dat[27] := 3;
	dat[28] := 3;
	dat[29] := 1;
	dat[30] := 0;
	dat[31] := 0;
	dat[32] := 17;
	dat[33] := 2;
	dat[34] := 4;
	dat[35] := 3;
	dat[36] := 3;
	dat[37] := 1;
	dat[38] := 0;
	dat[39] := 0;
	dat[40] := 17;
	dat[41] := 0;
END_IF;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: WORLD_WEATHER_ICON_OSC
IEC_LANGUAGE: ST
*)
IF ACTIVATE AND act_last = FALSE THEN
	x := LIMIT(0,WW.CUR.WEATHER_ICON,41);
	WW.CUR.WEATHER_ICON := dat[x];
	FOR i := 0 TO 4 DO
		x := LIMIT(0,WW.DAY[i].WEATHER_ICON,41);
		WW.DAY[i].WEATHER_ICON := dat[x];
	END_FOR;
END_IF;
act_last := ACTIVATE;

(* revision history
ks	04. may. 2011	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
