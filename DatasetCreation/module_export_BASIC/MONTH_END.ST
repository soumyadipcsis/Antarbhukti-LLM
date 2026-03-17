(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	7. oct. 2008
programmer 	hugo
tested by	oscat

returns the date for the last day of the current month in the current year.
(*@KEY@:END_DESCRIPTION*)
FUNCTION MONTH_END:UDINT

(*Group:Default*)


VAR_INPUT
	IDATE :	UDINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MONTH_END
IEC_LANGUAGE: ST
*)
MONTH_END := SET_DATE(YEAR_OF_DATE(idate),MONTH_OF_DATE(idate)+1,1) - UDINT#86400;

(* revision history
hm	15. jun. 2008	rev 1.0
	original version	

hm	7. oct. 2008	rev 1.1
	changed function year to year_of_date
	changed function month to month_of_date

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
