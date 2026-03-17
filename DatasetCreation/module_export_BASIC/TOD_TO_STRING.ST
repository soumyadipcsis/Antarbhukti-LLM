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
FUNCTION_BLOCK TOD_TO_STRING

(*Group:Default*)


VAR_INPUT
	ITOD :	UDINT;
END_VAR


VAR_OUTPUT
	TOD_STRING :	STRING;
END_VAR


VAR
	st_tmp1 :	STRING;
	st_tmp2 :	STRING;
	cur_hours :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TOD_TO_STRING
IEC_LANGUAGE: ST
*)
cur_hours := hour(ITOD);
IF cur_hours = 0 THEN
  st_tmp2 := '%01dh';
ELSE
  st_tmp2 := '%dh';
END_IF;

st_tmp1 := CONCAT(INT_TO_STRING(cur_hours,st_tmp2),INT_TO_STRING(minute(ITOD),'%02dm'));
TOD_STRING := CONCAT(st_tmp1,UDINT_TO_STRING(ITOD MOD UDINT#60000 / UDINT#1000,'%02us'));
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
