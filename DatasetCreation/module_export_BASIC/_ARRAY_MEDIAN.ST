(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.5	16 mar 2008
programmer 	hugo
tested by	tobias

this function will calculate the median of a given array.
in order to do so the ariginal array is sorted and stays sorted after the function finishes
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _ARRAY_MEDIAN

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_ARRAY_MEDIAN :	REAL;
END_VAR


VAR
	i :	INT;
	i2 :	INT;
	stop :	INT;
	_array_sort :	_ARRAY_SORT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _ARRAY_MEDIAN
IEC_LANGUAGE: ST
*)

(* Array sortieren *)
_array_sort.pt   := pt;
_array_sort.size := size;
_array_sort();
pt := _array_sort.pt;

stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
IF even(INT_TO_DINT(stop)) THEN
    i := WORD_TO_INT(SHR(INT_TO_WORD(stop),1));
    i2 := i+1;
	_array_median := (pt[i] + pt[i2]) * 0.5;
ELSE
    i := WORD_TO_INT(SHR(INT_TO_WORD(stop),1))+1;
	_array_median := pt[i];
END_IF;

(* revision history
hm 	3.3.2007		rev 1.1
	corrected an error, changed the statement line 14	i := TRUNC(stop/2); to i := stop/2;

hm		22. sep 2007	rev 1.2
	changed algorithm to use _array_soft for performance reasons

hm		8. oct 2007		rev 1.3
	deleted unused variables m and temp

hm		14. nov 2007	rev 1.4
	corrected a problem with size calculation

hm		16.3. 2008		rev 1.5
	changed type of input size to uint
	performance improvements
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
