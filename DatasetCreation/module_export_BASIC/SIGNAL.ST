(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.0	13 dec 2007
programmer 	hugo
tested by	tobias

this function generates an output signal according to a bit pattern SIG.
the patter is shifted to the output in time steps of TS.
ts defaults to 128 ms if not specified.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SIGNAL

(*Group:Default*)


VAR_INPUT
	IN :	BOOL;
	SIG :	BYTE;
	TS :	TIME;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
END_VAR


VAR
	tx :	DWORD;
	step :	BYTE;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: SIGNAL
IEC_LANGUAGE: ST
*)
IF in THEN
	(* an alarm is present read system time first *)
    T_PLC_MS();
    tx:= UDINT_TO_DWORD(T_PLC_MS.T_PLC_MS);

	(* calculate the step counter which is the lowest 3 bits of (time / ts) *)
	IF ts > t#0s THEN
		step := DWORD_TO_BYTE(UDINT_TO_DWORD(DWORD_TO_UDINT(tx) / TIME_TO_UDINT(ts)) AND DWORD#16#0000_0007);
	ELSE
		step := DWORD_TO_BYTE(SHR(tx,7) AND DWORD#16#0000_0007);
	END_IF;
	(* convert the value 0-7 in step into one bit only (bit 0-7) *)
	step := SHL(BYTE#1,_BYTE_TO_INT(step));
	(* generate the output signal *)
	Q := (step AND sig) > BYTE#0;
ELSE
	Q := FALSE;
END_IF;

(* revision history
hm	13.12.2007		rev 1.0
	original version

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
