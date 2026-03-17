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

YAHOO_WEATHER_ICON_OSCAT ändert die ICON Nummer auf den OSCAT-Standard um
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK YAHOO_WEATHER_ICON_OSCAT

(*Group:Default*)


VAR_INPUT
	ACTIVATE :	BOOL;
END_VAR


VAR_IN_OUT
	YW :	oscat_YAHOO_WEATHER_DATA;
END_VAR


VAR
	act_last :	BOOL;
	x :	INT;
	init :	BOOL;
	dat :	oscat_YAHOO_WEATHER_aI0_48;
END_VAR


(*@KEY@: WORKSHEET
NAME: init
IEC_LANGUAGE: ST
*)
IF not init THEN
    init := TRUE;

	dat[00] := 4;
	dat[01] := 2;
	dat[02] := 2;
	dat[03] := 4;
	dat[04] := 17;
	dat[05] := 1;
	dat[06] := 3;
	dat[07] := 1;
	dat[08] := 2;
	dat[09] := 2;
	dat[10] := 2;
	dat[11] := 2;
	dat[12] := 2;
	dat[13] := 3;
	dat[14] := 3;
	dat[15] := 3;
	dat[16] := 3;
	dat[17] := 5;
	dat[18] := 3;
	dat[19] := 6;
	dat[20] := 7;
	dat[21] := 14;
	dat[22] := 8;
	dat[23] := 9;
	dat[24] := 9;
	dat[25] := 10;
	dat[26] := 9;
	dat[27] := 11;
	dat[28] := 12;
	dat[29] := 11;
	dat[30] := 12;
	dat[31] := 13;
	dat[32] := 14;
	dat[33] := 15;
	dat[34] := 16;
	dat[35] := 4;
	dat[36] := 14;
	dat[37] := 4;
	dat[38] := 17;
	dat[39] := 2;
	dat[40] := 2;
	dat[41] := 3;
	dat[42] := 3;
	dat[43] := 3;
	dat[44] := 12;
	dat[45] := 2;
	dat[46] := 3;
	dat[47] := 4;
	dat[48] := 0;
END_IF;

(*@KEY@: END_WORKSHEET *)
(*@KEY@: WORKSHEET
NAME: YAHOO_WEATHER_ICON_OSC
IEC_LANGUAGE: ST
*)
IF ACTIVATE AND act_last = FALSE THEN
	x := MIN(YW.CUR_CONDITIONS_CODE,48);
	YW.CUR_CONDITIONS_ICON := dat[x];
	x := MIN(YW.FORCAST_TODAY_CODE,48);
	YW.FORCAST_TODAY_ICON := dat[x];
	x := MIN(YW.FORCAST_TOMORROW_CODE,48);
	YW.FORCAST_TOMORROW_ICON := dat[x];
END_IF;
act_last := ACTIVATE;

(* revision history
ks	04. may. 2011	rev 1.0
	original version
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
