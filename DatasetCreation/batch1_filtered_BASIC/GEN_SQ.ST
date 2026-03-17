(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	16. feb. 2011
programmer 	    hugo
tested by		tobias

gen_sq generates square wave signal with programmable period time.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK GEN_SQ

(*Group:Default*)


VAR_INPUT
	PT :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	init :	BOOL;
	tn :	TIME;
	tx :	TIME;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: GEN_SQ
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF NOT init THEN
	init := TRUE;
	tn := tx;
	Q := TRUE;
ELSIF tx - tn >= DWORD_TO_TIME(SHR(TIME_TO_DWORD(PT),1)) THEN
	Q := NOT Q;
	tn := tn + DWORD_TO_TIME(SHR(TIME_TO_DWORD(pt),1));
END_IF;

(* revision history
hm	4. aug 2006	rev 1.0
	original version

hm	17. sep 2007	rev 1.1
	replaced time() with T_PLC_MS() for compatibility reasons

hm	18. jul. 2009	rev 1.2
	improved accuracy

hm	16. feb 2011	rev 1.3
	corrected an error with timer overflow 
*)




(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
