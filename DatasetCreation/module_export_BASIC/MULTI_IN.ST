(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SENSOR
*)
(*@KEY@:DESCRIPTION*)
version 1.4	18. jul. 2009
programmer 	oscat
tested by	oscat

multi_in is a signal conditioning function which can be configured in 8 different ways.
it is used to read multiple sensors for the same value and protect the user from broken sensors or invalid data from sensors.

multi_in can be configured in different ways:
	mode = 0 means the the avg of the 3 inputs is used, this mode is the default mode.
	mode = 1 means in_1 is used.
	mode = 2 means in_2 is used.
	mode = 3 means in_3 is used.
	mode = 4 means default is used.
	mode = 5 means the lowest of the 3 external temperatures is used.
	mode = 6 means the higest externnal temperature is used.
	mode = 7 means the midlle input is used, if there are only two working, the lowest input is used.
	mode > 7 ,eans output is 0 at all times.
	in any config mode, an input higher then in_max or lower then in_min is ignored to prevent values from broken sensors or wires.
	if all inputs are higher then in_max or lower then in_min, a default value (default) is used.


(*@KEY@:END_DESCRIPTION*)
FUNCTION MULTI_IN:REAL

(*Group:Default*)


VAR_INPUT
	IN_1 :	REAL;
	IN_2 :	REAL;
	IN_3 :	REAL;
	DEFAULT :	REAL;
	IN_MIN :	REAL;
	IN_MAX :	REAL;
	MODE :	BYTE;
END_VAR


VAR
	count :	INT;
	F1 :	BOOL;
	F2 :	BOOL;
	F3 :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MULTI_IN
IEC_LANGUAGE: ST
*)
F1 :=  in_1 > in_min AND in_1 < in_max;
F2 :=  in_2 > in_min AND in_2 < in_max;
F3 :=  in_3 > in_min AND in_3 < in_max;

CASE _BYTE_TO_INT(mode) OF
0:	count := 0;
	IF F1 THEN
		count := count + 1;
		MULTI_IN := in_1;
	ELSE
		MULTI_IN := 0.0;
	END_IF;
	IF F2 THEN
		count := count + 1;
		MULTI_IN := MULTI_IN + in_2;
	END_IF;
	IF F3 THEN
		count := count + 1;
		MULTI_IN := MULTI_IN + in_3;
	END_IF;
	MULTI_IN := SEL_REAL(count = 0, MULTI_IN / INT_TO_REAL(count), default);

1:	MULTI_IN := SEL_REAL(F1, default, IN_1);

2:	MULTI_IN := SEL_REAL(F2, default, IN_2);

3:	MULTI_IN := SEL_REAL(F3, default, IN_3);

4:	MULTI_IN := default;

5:	MULTI_IN := SEL_REAL(F1, in_max, IN_1);
	IF F2 AND in_2 < MULTI_IN THEN MULTI_IN := in_2; END_IF;
	IF F3 AND in_3 < MULTI_IN THEN MULTI_IN := in_3; END_IF;
	IF MULTI_IN = in_max THEN MULTI_IN := default; END_IF;

6:	MULTI_IN := SEL_REAL(F1, in_min, IN_1);
	IF F2 AND in_2 > MULTI_IN THEN MULTI_IN := in_2; END_IF;
	IF F3 AND in_3 > MULTI_IN THEN MULTI_IN := in_3; END_IF;
	IF MULTI_IN = in_min THEN MULTI_IN := default; END_IF;

7:	IF F1 AND F2 AND F3 THEN MULTI_IN := MID3(in_1, in_2, in_3);
	ELSIF F1 AND F2 THEN MULTI_IN := MIN(in_1, in_2);
	ELSIF F1 AND F3 THEN MULTI_IN := MIN(in_1, in_3);
	ELSIF F2 AND F3 THEN MULTI_IN := MIN(in_2, in_3);
	ELSIF F1 THEN MULTI_IN := in_1;
	ELSIF F2 THEN MULTI_IN := in_2;
	ELSIF F3 THEN MULTI_IN := in_3;
	ELSE MULTI_IN := default;
	END_IF;

END_CASE;

(*
hm 1.1.2007		rev 1.1
	changed midr to mid3 function

hm	14. 10. 2008	rev 1.2
	corrected an error for in_3 overrange detection
	improved performance

hm	11. mar. 2009	rev 1.3
	changed real constants to use dot syntax

hm	18. jul. 2009	rev 1.4
	improved performance
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
