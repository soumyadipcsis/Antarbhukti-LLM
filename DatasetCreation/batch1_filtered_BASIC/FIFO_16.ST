(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.MEMORY
*)
(*@KEY@:DESCRIPTION*)
version 2.0	24. jul. 2009
programmer 	hugo
tested by	oscat

16 Dword FIFO memory
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FIFO_16

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
	fifo :	oscat_ardw_0_15;
	pr :	INT;
	pw :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIFO_16
IEC_LANGUAGE: ST
*)
IF RST THEN
	pw := pr;
	FULL := FALSE;
	EMPTY := TRUE;
	Dout := DWORD#0;
ELSIF E THEN
	IF NOT EMPTY AND RD THEN
		Dout := fifo[pr];
		pr := INC1(pr,16);
		EMPTY := pr = pw;
		FULL := FALSE;
	END_IF;
	IF NOT FULL AND WD THEN
		fifo[pw] := Din;
		pw := INC1(pw,16);
		FULL := pw = pr;
		EMPTY := FALSE;
	END_IF;
END_IF;


(* revision history

hm	4. aug. 2006	rev 1.0
	original version

hm	19. feb 2008	rev 1.1
	performance improvements

hm	17. oct. 2008	rev 1.2
	improved performance

ks	27. oct. 2008	rev 1.3
	optimized coding

hm	14. mar. 2009	rev 1.4
	removed double assignments

hm 24. jul. 2009	rev 2.0
	chaged inputs E and WR to E, WD and WR
	allow read and write in one cycle

*)


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
