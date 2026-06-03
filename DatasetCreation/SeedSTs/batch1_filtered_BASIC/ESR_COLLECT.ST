(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.4	1. dec. 2009
programmer 	hugo
tested by	tobias

ESR_collect collects esr data from up to 8 esr_mon modules and stroes them in an output array.
the output pos will display the position of the last element in the array. if the array is empty, pos = -1
when to buffer is read by followon modules. pos has to be reset to -1
if the array will be full, the buffer will be refilled starting at position 0.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ESR_COLLECT

(*Group:Default*)


VAR_INPUT
	ESR_0 :	oscat_ESR_3;
	ESR_1 :	oscat_ESR_3;
	ESR_2 :	oscat_ESR_3;
	ESR_3 :	oscat_ESR_3;
	ESR_4 :	oscat_ESR_3;
	ESR_5 :	oscat_ESR_3;
	ESR_6 :	oscat_ESR_3;
	ESR_7 :	oscat_ESR_3;
	RST :	BOOL;
END_VAR


VAR_IN_OUT
	POS :	INT;
END_VAR


VAR_OUTPUT
	ESR_OUT :	oscat_ESR_31;
END_VAR


VAR
	cnt :	INT := -1;
	max_in :	INT := 3;
	max_out :	INT := 32;
END_VAR


(*@KEY@: WORKSHEET
NAME: ESR_COLLECT
IEC_LANGUAGE: ST
*)
IF rst OR cnt < 0 THEN
	pos := -1;
ELSE
	FOR cnt := 0 TO max_in DO
	IF esr_0[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_0[cnt]; END_IF;
	IF esr_1[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_1[cnt]; END_IF;
	IF esr_2[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_2[cnt]; END_IF;
	IF esr_3[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_3[cnt]; END_IF;
	IF esr_4[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_4[cnt]; END_IF;
	IF esr_5[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_5[cnt]; END_IF;
	IF esr_6[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_6[cnt]; END_IF;
	IF esr_7[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_7[cnt]; END_IF;
   END_FOR;
END_IF;


(* revision history
hm	26.jan 2007	rev 1.0
	original version

hm	8. dec 2007	rev 1.1
	added reset input

ks	27. oct. 2008	rev 1.2
	optimized code for performance

ks	12. nov. 2009	rev 1.3
	output pos was not pointing to last value	

hm	1. dec. 2009	rev 1.4
	changed pos to be I/O
	reduced output array size to 32 elements
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
