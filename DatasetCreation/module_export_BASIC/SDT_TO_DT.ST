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

converts Structured date time (SDT) to Date Time
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SDT_TO_DT

(*Group:Default*)


VAR_INPUT
	DTI :	oscat_SDT;
END_VAR


VAR_OUTPUT
	SDT_TO_DT :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SDT_TO_DT
IEC_LANGUAGE: ST
*)
SDT_TO_DT := SET_DT(DTI.YEAR, DTI.MONTH, DTI.DAY, DTI.HOUR, DTI.MINUTE, DTI.SECOND);

(* revision history

hm 18. oct. 2008	rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
