(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	4. apr. 2008
programmer 	hugo
tested by	tobias

this function will return true if the given array is sorted in an ascending order.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK IS_SORTED

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	IS_SORTED :	BOOL;
END_VAR


VAR
	i :	INT;
	i2 :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: IS_SORTED
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
stop := stop -1;
FOR i := 1 TO stop DO
    i2 := i+1;
	IF pt[i] > pt[i2] THEN
		IS_SORTED := FALSE;
		RETURN;
	END_IF;
END_FOR;

IS_SORTED := TRUE;

(* revision history

hm 	29. mar. 2008 	rev 1.0
	original version

hm	4. apr. 2008	rev 1.1
	added type conversion to avoid warnings under codesys 3.0
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
