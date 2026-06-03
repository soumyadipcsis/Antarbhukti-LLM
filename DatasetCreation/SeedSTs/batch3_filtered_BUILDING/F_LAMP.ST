(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ELECTRICAL
*)
(*@KEY@:DESCRIPTION*)
version 1.2	22. oct. 2008
programmer 	hugo
tested by	oscat

F_Lamp is an interface to flourescent lamps. its main purpose is to protect flourescent lamps from dimming within the first T_NO_DIMM Time.
If Flourescent Lamps are dimmed during the first 100 hours the lifetime of the lamp is reduced dramatically.
The interface also counts ontime and cycles of the lamp for maintanance purposes.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK F_LAMP

(*Group:Default*)


VAR_INPUT
	SWITCH :	BOOL;
	DIMM :	BYTE := BYTE#255;
	RST :	BOOL;
	T_NO_DIMM :	UINT := UINT#100;
	T_MAINTENANCE :	UINT := UINT#15000;
END_VAR


VAR_OUTPUT
	LAMP :	BYTE;
	STATUS :	BYTE;
END_VAR


VAR_IN_OUT
	ONTIME :	UDINT;
	CYCLES :	UDINT;
END_VAR


VAR
	runtime :	ONTIME;
END_VAR


(*@KEY@: WORKSHEET
NAME: F_LAMP
IEC_LANGUAGE: ST
*)
runtime(in := switch, SECONDS := ONTIME , CYCLES := CYCLES);
CYCLES := runtime.CYCLES;
ONTIME := runtime.SECONDS;

IF RST THEN
	ONTIME := UDINT#0;
	CYCLES := UDINT#0;
END_IF;
IF SWITCH THEN
	IF ontime < UINT_TO_UDINT(T_NO_DIMM) * UDINT#3600 THEN
		LAMP := BYTE#255;
		STATUS := BYTE#111;
	ELSE
		LAMP := DIMM;
		STATUS := BYTE#112;
	END_IF;
ELSE
	LAMP := BYTE#0;
	STATUS := BYTE#110;
END_IF;

IF ontime >= UINT_TO_UDINT(T_maintenance) * UDINT#3600 AND T_Maintenance > UINT#0 THEN
	STATUS := BYTE#120;
END_IF;

(* revision history
hm	8. feb. 2007	rev 1.1
	original version

hm	22. oct. 2008	rev 1.2
	changed use of ontime for ontime 2.0
	ontime is now in seconds not hours
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
