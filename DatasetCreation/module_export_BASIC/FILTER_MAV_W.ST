(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.4	26. MAR. 2011
programmer 	    hugo
tested by		oscat

FILTER_MAV_W is a moving average filter with programmable length N for WORD Data.
 
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FILTER_MAV_W

(*Group:Default*)


VAR_INPUT
	X :	WORD;
	N :	UINT;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Y :	WORD;
END_VAR


VAR
	init :	BOOL;
	buffer :	oscat_FILTER_MAV_W;
	i :	INT;
	sum :	UDINT;
	tmp :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FILTER_MAV_W
IEC_LANGUAGE: ST
*)
(* limit N to size of buffer *)
N := MIN(N, UINT#32);

(* startup initialisation *)
IF NOT init OR rst OR N = UINT#0 THEN
	init := TRUE;
	tmp := UINT_TO_INT(N) - 1;
	FOR i := 1 TO tmp DO
		buffer[i] := X;
	END_FOR;
	sum := UINT_TO_UDINT(WORD_TO_UINT(Y) * N);
	Y := X;
ELSE
	tmp := UINT_TO_INT(N);
	i := INC1(i, tmp);
	sum := sum + WORD_TO_UDINT(X) - WORD_TO_UDINT(buffer[i]);
	Y := UDINT_TO_WORD(sum / UINT_TO_UDINT(N));
	buffer[i] := X;
END_IF;

(*
hm 13. oct. 2008	rev 1.0
	original version

hm	18. oct. 2008	rev 1.1
	added typecast to avoid warnings

hm	24. nov. 2008	rev 1.2
	added typecasts to avoid warnings
	avoid devide by 0 if N = 0

hm	23. feb. 2009	rev 1.3
	limit N to max array size

hm	26. mar. 2011	rev 1.4
	corrected error in calculation
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
