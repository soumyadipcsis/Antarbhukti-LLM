(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	16 mar 2008
programmer 	hugo
tested by	tobias

this function will initialize a given array with a value init.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _ARRAY_INIT

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
	INIT :	REAL;
END_VAR


VAR_OUTPUT
	_ARRAY_INIT :	BOOL;
END_VAR


VAR
	i :	INT;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _ARRAY_INIT
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);

FOR i := 1 TO stop DO
	pt[i] := init;
END_FOR;
_array_init := TRUE;

(* revision History

hm 6.1.2007		rev 1.1
	change type of function to bool
	added  array_init := true to set output true.

hm	14.11.2007	rev 1.2
	changed stop calculation to be more efficient

hm	16.3. 2008		rev 1.3
	changed type of input size to uint
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
