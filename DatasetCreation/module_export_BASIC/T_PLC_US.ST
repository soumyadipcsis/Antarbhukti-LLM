(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.MEASUREMENTS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	12 nov 2007
programmer 	hugo
tested by	tobias

T_PLC_US reads the internal PLC timer and return the time, it has the advantage to be able to set a debug mode 
and speed up the counter to test the plc timer overrun which occurs every 50 days respectively 25 days at siemens S7
this routine also allows to correct the behavior of s7 where the internal plc counter will not count all 32 bits.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK T_PLC_US

(*Group:Default*)


VAR_OUTPUT
	T_PLC_US :	UDINT;
END_VAR


VAR_EXTERNAL
	PLC_TICKS_PER_SEC :	INT;(*Systemticks pro Sekunde*)
	PLC_SYS_TICK_CNT :	DINT;(*Anzahl der Systemticks*)
END_VAR


(*Group:Debug-Parameter*)


VAR
	debug :	BOOL;(*Debug-Mode ON / OFF*)
	N :	INT;(*Debug-Faktor*)
	Offset :	UDINT;(*Debug-Offset*)
	temp :	DWORD := DWORD#1;(*Debug-Offset*)
	mode :	BOOL;(*modus*)
	faktor :	UDINT;(*Systemtakt-Faktor*)
	init :	BOOL;
	v_plc_ticks_per_sec :	UDINT;
	base :	UDINT := UDINT#1000000;
END_VAR


(*@KEY@: WORKSHEET
NAME: T_PLC_US
IEC_LANGUAGE: ST
*)
IF init = FALSE THEN
	v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
	IF v_plc_ticks_per_sec = UDINT#1024 THEN
		faktor := UDINT#1000;
		mode := FALSE;
	ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
		IF v_plc_ticks_per_sec <= base THEN
			faktor := base / v_plc_ticks_per_sec;
			mode := FALSE;
		ELSE
			faktor := v_plc_ticks_per_sec / base;
			mode := TRUE;
		END_IF;
	ELSE
		faktor := UDINT#1;
	END_IF;
	init := TRUE;
END_IF;

IF mode THEN
	T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
ELSE
	T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
END_IF;

IF debug THEN
	T_PLC_US := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_US),N) OR SHL(temp,N)) - UDINT#1) + Offset;
END_IF;

(* revision history
hm	14.9.2007	rev 1.0
	original version

hm	12. nov 2007	rev 1.1
	added temporaray variable tx because some compilers could not handle time() as an argument

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
