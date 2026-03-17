(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: EMULATION
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DT_TO_STRING

(*Group:Default*)


VAR_INPUT
	IDT :	UDINT;
END_VAR


VAR_OUTPUT
	DT_STRING :	STRING;
END_VAR


VAR
	st_tmp1 :	STRING;
	st_tmp2 :	STRING;
END_VAR


(*@KEY@: WORKSHEET
NAME: DT_TO_STRING
IEC_LANGUAGE: ST
*)
st_tmp2 := CONCAT(INT_TO_STRING(YEAR_OF_DATE(IDT),'%04d-'),INT_TO_STRING(MONTH_OF_DATE(IDT),'%02d-'));
st_tmp1 := CONCAT(INT_TO_STRING(day_of_month(IDT),'%02d-'),INT_TO_STRING(hour_of_DT(IDT),'%02d:'));
st_tmp2 := CONCAT(st_tmp2,st_tmp1);
st_tmp1 := CONCAT(INT_TO_STRING(minute_of_DT(IDT),'%02d:'),INT_TO_STRING(second_of_DT(IDT),'%02d'));
st_tmp2 := CONCAT(st_tmp2,st_tmp1);
DT_STRING := st_tmp2;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
