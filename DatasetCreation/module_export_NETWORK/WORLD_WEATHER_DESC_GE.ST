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

WORLD_WEATHER_DESC_GE ‰ndert die englischen Wetterbeschreibungstexte auf deutsche Texte um
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK WORLD_WEATHER_DESC_GE

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
	y :	INT;
	str :	oscat_STRING60;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: WORLD_WEATHER_DESC_GE
IEC_LANGUAGE: ST
*)
IF ACTIVATE AND act_last = FALSE THEN
	i := 0;
	FOR y := 1 TO 12 DO
		CASE y OF
		1,3,5,7,9:	x :=  WW.DAY[i].WEATHER_CODE;
		2,4,6,8,10:	WW.DAY[i].WEATHER_DESC := str;
					i := i + 1;
		11:			x :=  WW.CUR.WEATHER_CODE;
		12:			WW.CUR.WEATHER_DESC := str;
		END_CASE;

		CASE x OF
			113	:	str := 'heiter/sonnig';
			116	:	str := 'stellenweise wolkig';
			119	:	str := 'wolkig';
			122	:	str := 'bewˆlkt';
			143	:	str := 'Nebel';
			176	:	str := 'stellenweise nahegelegener Regen';
			179	:	str := 'stellenweise nahegelegener Schneefall';
			182	:	str := 'stellenweise nahegelegener Eisregen';
			185	:	str := 'stellenweise gefrierender Niesel';
			200	:	str := 'nahegelegene Sturm';
			227	:	str := 'Schneetreiben';
			230	:	str := 'Schneesturm';
			248	:	str := 'Nebel';
			260	:	str := 'gefrierender Nebel';
			263	:	str := 'stellenweise leichter Nieselregen';
			266	:	str := 'leichter Niesel';
			281	:	str := 'gefrierender Nieselregen';
			284	:	str := 'stark gefrierender Nieselregen';
			293	:	str := 'stellenweise leichter Regen';
			296	:	str := 'leichter Regen';
			299	:	str := 'zeitweise etwas Regen';
			302	:	str := 'm‰ﬂiger Regen';
			305	:	str := 'zeitweise etwas starker Regen';
			308	:	str := 'starker Regen';
			311	:	str := 'leichter gefrierender Regen';
			314	:	str := 'm‰ﬂiger oder starker Eisregen';
			317	:	str := 'leichter Eisregen';
			320	:	str := 'm‰ﬂiger oder starker Eisregen';
			323	:	str := 'stellenweise leichter Schneefall';
			326	:	str := 'leichter Scheefall';
			329	:	str := 'stellenweise moderater Schneefall';
			332	:	str := 'm‰ﬂiger Schnee';
			335	:	str := 'stellenweise starker Scheefall';
			338	:	str := 'starker Schneefall';
			350	:	str := 'Hagel';
			353	:	str := 'leichte Regenf‰lle';
			356	:	str := 'm‰ﬂiger oder starker Regenfall';
			359	:	str := 'sintflutartige Regenf‰lle';
			362	:	str := 'leichter Eisregen';
			365	:	str := 'm‰ﬂiger oder starker Eisregen';
			368	:	str := 'leichte Schneeschauer';
			371	:	str := 'm‰ﬂiger oder starker Schneefall';
			374	:	str := 'leichter Hagel';
			377	:	str := 'm‰ﬂiger oder starker Hagel';
			386	:	str := 'stellenweise leichter Regen in Gewittergebiet';
			389	:	str := 'm‰ﬂiger oder starker Regen in Gewittergebiet';
			392	:	str := 'stellenweise leichter Schneefall in Gewittergebiet';
			395	:	str := 'm‰ﬂiger oder starker Schnee in Gewittergebiet';
		ELSE
			str := 	'nicht verf¸gbar';
		END_CASE;
	END_FOR;
END_IF;
act_last := ACTIVATE;

(* revision history
ks	04. may. 2011	rev 1.0
	original version
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
