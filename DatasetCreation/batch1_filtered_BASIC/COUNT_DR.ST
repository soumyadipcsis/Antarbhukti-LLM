(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.1	20. jan. 2011
programmer 	hugo
tested BY	tobias

Count_DR is a DWORD counter with independen up and dn inputs. the counter counts from 0 to mx and continues at 0 after is has reached mx
a step input sets the counters stepping width.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK COUNT_DR

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	IN :	DWORD;
	UP :	BOOL;
	DN :	BOOL;
	STEP :	DWORD := DWORD#1;
	MX :	DWORD := DWORD#16#FFFF_FFFF;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	CNT :	DWORD;
END_VAR


VAR
	CNT2 :	UDINT;
	STEP2 :	UDINT;
	MX2 :	UDINT;
	last_up :	BOOL;
	last_dn :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: COUNT_DR
IEC_LANGUAGE: ST
*)
STEP2 := DWORD_TO_UDINT(STEP);
MX2   := DWORD_TO_UDINT(MX);
CNT2  := DWORD_TO_UDINT(CNT);

IF rst THEN
	CNT2 := UDINT#0;
ELSIF set THEN
	CNT2 := LIMIT(UDINT#0,DWORD_TO_UDINT(in),mx2);
ELSIF up AND NOT last_up THEN
	IF STEP2 > MX2 - CNT2 THEN
		CNT2 := CNT2 - MX2 + STEP2 - UDINT#1;
	ELSE
		CNT2 := CNT2 + STEP2;
	END_IF;
ELSIF dn AND NOT last_dn THEN
	IF STEP2 > CNT2 THEN
		CNT2 := CNT2 - STEP2 + MX2 + UDINT#1;
	ELSE
		CNT2 := CNT2 - STEP2;
	END_IF;
END_IF;
last_up := up;
last_dn := dn;

CNT := UDINT_TO_DWORD(CNT2);

(* revision history
hm	12. jun 2008	rev 1.0
	original version

hm	20. jan. 2011	rev 1.1
	corrected init value of MX to 16#FFFFFFFF

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
