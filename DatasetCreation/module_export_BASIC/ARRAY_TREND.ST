(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	hugo
tested by		tobias

this function will calculate the trend of a given array.
trend will calculate the avg of the first half of the array and then the avg of the second half, trend = avg2 - avg1.
for example:  [0,1,4,5,3,4,6,3] = 4 - 2.5 = 1.5

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ARRAY_TREND

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	ARRAY_TREND :	REAL;
END_VAR


VAR
	d :	INT;
	i :	INT;
	stop :	INT;
	stop2 :	INT;
	x :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ARRAY_TREND
IEC_LANGUAGE: ST
*)
x := 0.0;
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
stop2 := WORD_TO_INT(SHR(INT_TO_WORD(stop),1)); 
IF even(INT_TO_DINT(stop)) THEN d:=0; ELSE d:=1;END_IF;

FOR i := 1 TO stop2+d DO
    x := x - pt[i];
END_FOR; 
FOR i := stop2+1 TO stop DO
    x := x + pt[i];
END_FOR; 
array_trend := x / INT_TO_REAL(stop2+d);

(* revision history
hm	2 oct 2007	rev 1.0
	original version

hm	12 dec 2007	rev 1.1
	changed code for better performance

hm	16. mar. 2008	rev 1.2
	changed type of input size to uint

hm	10. mar. 2009	rev 1.3
	added type conversions for compatibility reasons
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
