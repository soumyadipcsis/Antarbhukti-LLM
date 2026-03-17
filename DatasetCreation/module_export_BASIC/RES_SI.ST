(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SENSOR
*)
(*@KEY@:DESCRIPTION*)
version 1.2	11. mar. 2009
programmer 	hugo
tested by	tobias

this function returs the resistance for a silicon sensor for a temperature range from -50..+150 °C
for example KTY10 normaly Rs at 25 °C
(*@KEY@:END_DESCRIPTION*)
FUNCTION RES_SI:REAL

(*Group:Default*)


VAR_INPUT
	T :	REAL;
	RS :	REAL;
	TS :	REAL;
END_VAR


VAR
	TX :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: RES_SI
IEC_LANGUAGE: ST
*)
TX := T - TS;
RES_SI := RS * ( 1.0 + 7.64E-3 * TX + 1.66E-5 * TX * TX);

(* revision history
hm	4. aug 2006	rev 1.0
	original version

hm	2. dec 2007	rev 1.1
	changed code for better performance

hm	11. mar. 2009	rev 1.2
	changed real constants to use dot syntax

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
