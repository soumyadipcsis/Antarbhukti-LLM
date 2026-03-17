(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	30. mar. 2008
programmer 	kurt
tested by	hugo

this function will randomly shuffle the elements of an array
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _ARRAY_SHUFFLE

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_ARRAY_SHUFFLE :	BOOL;
END_VAR


VAR
	temp :	REAL;
	pos :	INT;
	i :	INT;
	stop :	INT;
	rdm2 :	rdm2;
END_VAR


(*@KEY@: WORKSHEET
NAME: _ARRAY_SHUFFLE
IEC_LANGUAGE: ST
*)
stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
FOR i := 1 TO stop DO
        rdm2(last:=i+pos,low:=1,high:=stop);
        pos := rdm2.rdm2;
        (* swap elements *)
        temp := pt[i];
        pt[i] := pt[pos];
        pt[pos] := temp;
END_FOR;

_ARRAY_SHUFFLE := TRUE;

(* revision History
hm 	4. mar 2008	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	changed type of input size to uint
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
