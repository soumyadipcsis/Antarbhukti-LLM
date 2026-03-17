(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: BUFFER_MANAGMENT
*)
(*@KEY@:DESCRIPTION*)
version 1.2	31. oct. 2008
programmer 	hugo
tested by	oscat

this function will initialize a given array of byte with 0.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _BUFFER_CLEAR

(*Group:Default*)


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	BUFFER_CLEAR :	BOOL;
END_VAR


VAR_IN_OUT
	PT :	oscat_arb_0_249;
END_VAR


VAR
	err :	INT;
	result :	WORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: _BUFFER_CLEAR
IEC_LANGUAGE: ST
*)
result:=MEMSET(err,BYTE#00,UINT_TO_DINT(size),pt[0]);
BUFFER_CLEAR := (err = 0);

(* revision History
hm 	5. mar. 2008	rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	added type conversion to avoid warnings under codesys 30
	chaged type of input size to uint
	deleted unused variable i

hm	31. oct. 2008	rev 1.2
	corrected an error while routine would write outside of arrays

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
