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

converts date_time to Structured date time (SDT)
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DT_TO_SDT

(*Group:Default*)


VAR_INPUT
	DTI :	UDINT;
END_VAR


VAR_OUTPUT
	SDT :	oscat_SDT;
END_VAR


VAR
	tmp :	UDINT;
	tdt :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DT_TO_SDT
IEC_LANGUAGE: ST
*)
tmp := DT_TO_DATE(dti);
tdt := dti - tmp;
SDT.YEAR := YEAR_OF_DATE(tmp);
SDT.MONTH := MONTH_OF_DATE(tmp);
SDT.DAY := DAY_OF_MONTH(tmp);
SDT.WEEKDAY := DAY_OF_WEEK(tmp);
SDT.SECOND := UDINT_TO_INT(tdt MOD UDINT#60);
SDT.MINUTE := UDINT_TO_INT((tdt / UDINT#60) MOD UDINT#60);
SDT.HOUR := UDINT_TO_INT(tdt / UDINT#3600);

(* revision history

hm 18. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
