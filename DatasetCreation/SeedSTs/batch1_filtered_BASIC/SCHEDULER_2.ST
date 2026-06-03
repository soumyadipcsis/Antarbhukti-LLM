(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	29. sep 2008
programmer 	hugo
tested by	tobias

SCHEDULER_2 is used to call programs or function blocks at specific cycles.
C0..C3 defines after how many cycles the output becomes active.
O0..O3 defines a cycle offset at startup.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SCHEDULER_2

(*Group:Default*)


VAR_INPUT
	E0 :	BOOL;
	E1 :	BOOL;
	E2 :	BOOL;
	E3 :	BOOL;
	C0 :	UINT;
	C1 :	UINT;
	C2 :	UINT;
	C3 :	UINT;
	O0 :	UINT;
	O1 :	UINT;
	O2 :	UINT;
	O3 :	UINT;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
END_VAR


VAR
	sx :	UINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: SCHEDULER_2
IEC_LANGUAGE: ST
*)
Q0 := E0 AND (sx MOD C0 - O0 = UINT#0);
Q1 := E1 AND (sx MOD C1 - O1 = UINT#0);
Q2 := E2 AND (sx MOD C2 - O2 = UINT#0);
Q3 := E3 AND (sx MOD C3 - O3 = UINT#0);

(* increment cycle counter every cycle *)
sx := sx + UINT#1;


(* revision history
hm 29. sep. 2008		rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
