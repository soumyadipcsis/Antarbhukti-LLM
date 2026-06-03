(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.MEMORY
*)
(*@KEY@:DESCRIPTION*)
version 2.0	25. jul 2009
programmer 	hugo
tested by	oscat

16 Dword STACK memory

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK STACK_16

(*Group:Default*)


VAR_INPUT
	DIN :	DWORD;
	E :	BOOL := TRUE;
	RD :	BOOL;
	WD :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	DOUT :	DWORD;
	EMPTY :	BOOL := TRUE;
	FULL :	BOOL;
END_VAR


VAR
	pt :	INT;
	stack :	oscat_ardw_0_15;
END_VAR


(*@KEY@: WORKSHEET
NAME: STACK_16
IEC_LANGUAGE: ST
*)
IF RST THEN
	(* asynchronous reset for the fifo *)
	pt := 0;
	EMPTY := TRUE;
	FULL := FALSE;
	Dout := DWORD#0;
ELSIF E THEN
	IF NOT EMPTY AND RD THEN
		(* read one element *)
		pt := pt - 1;
		Dout := stack[pt];
		EMPTY := pt = 0;
		FULL := FALSE;
	END_IF;
	IF NOT FULL AND WD THEN
		(* write one element *)
		stack[pt] := Din;
		pt := pt + 1;
		FULL := pt > 15;
		EMPTY := FALSE;
	END_IF;
END_IF;


(* revision history
hm	4. aug. 2006	rev 1.0
	original version

hm	19. feb 2008	rev 1.1
	performance improvements

hm	17. oct. 2008	rev 1.2
	deleted unnecessary init with 0

hm	27. oct. 2008	rev 1.3
	optimized performance

hm	25. jul 2009	rev 2.0
	changed inputs to allow simultsaneous read and write
*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
