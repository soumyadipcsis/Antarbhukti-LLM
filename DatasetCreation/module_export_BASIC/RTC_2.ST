(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 1.4	27.	apr. 2011
programmer 	hugo
tested by	tobias

RTC_2 is a real time clock module which runs utc and generates local time from utc.
daylight savings time can be enabled with den and an additional local time is generated with a delay of ofs im minutes.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK RTC_2

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	SDT :	UDINT;
	SMS :	INT;
	DEN :	BOOL;
	OFS :	INT;
END_VAR


VAR_OUTPUT
	UDT :	UDINT;
	LDT :	UDINT;
	DSO :	BOOL;
	XMS :	INT;
END_VAR


VAR
	RT :	RTC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: RTC_2
IEC_LANGUAGE: ST
*)
(* call rtc *)
RT(SET := SET, SDT := SDT, SMS := SMS);
UDT := rt.xdt;
XMS := rt.XMS;

(* check for daylight savings time and set dso output *)
dso := DST(udt) AND DEN;

(* calculate time offset and set ldt output *)
LDT := UDT + _INT_TO_UDINT(ofs + BOOL_TO_INT(DSO) * 60) * UDINT#60;

(* revision history
hm		20. jan. 2008	rev 1.0
	original version

hm		20. feb. 2008	rev 1.1
	added Millisecond Set input

hm		12. jun. 2008	rev 1.2
	improved performance

hm		20. jan. 2011	rev 1.3
	changed offset to be in minutes

hm		27. apr. 2011	rev 1.4
	fixed error with local time calculation

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
