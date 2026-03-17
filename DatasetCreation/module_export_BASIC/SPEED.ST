(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	oscat

this function converts different speed units
any unused input can simply be left open.
different inputs connected at the same time will be added up.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SPEED

(*Group:Default*)


VAR_INPUT
	MS :	REAL;
	KMH :	REAL;
	KN :	REAL;
	MH :	REAL;
END_VAR


VAR_OUTPUT
	YMS :	REAL;
	YKMH :	REAL;
	YKN :	REAL;
	YMH :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SPEED
IEC_LANGUAGE: ST
*)
Yms := ms +
		kmh * 0.27777777777778 +
		kn * 0.5144444 +
		mh * 0.44704;
Ykmh := Yms * 3.6;
Ykn := Yms * 1.94384466037535;
Ymh := Yms * 2.23693629205440;

(*
Geschwindigkeit Meter durch Sekunde m/s 1 m/s = 3,6 km/h
km durch (pro) Stunde, nicht „Stundenkilometer“ verwenden
Knoten kn 1 kn = 1 sm/h = 0,5144 m/s

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
