(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	18. oct 2008
programmer 	hugo
tested by	oscat

converts date and time of day to Structured date time (SDT)
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DT2_TO_SDT

(*Group:Default*)


VAR_INPUT
	DI :	UDINT;
	TI :	UDINT;
END_VAR


VAR_OUTPUT
	SDT :	oscat_SDT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DT2_TO_SDT
IEC_LANGUAGE: ST
*)
SDT.YEAR := YEAR_OF_DATE(di);
SDT.MONTH := MONTH_OF_DATE(di);
SDT.DAY := DAY_OF_MONTH(di);
SDT.WEEKDAY := DAY_OF_WEEK(di);
SDT.MS := UDINT_TO_INT(ti MOD UDINT#1000);
SDT.SECOND := UDINT_TO_INT((ti / UDINT#1000) MOD UDINT#60);
SDT.MINUTE := UDINT_TO_INT((ti / UDINT#60000) MOD UDINT#60);
SDT.HOUR := UDINT_TO_INT(ti / UDINT#3600000);

(* revision history

hm 18. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
