(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.4	10. mar. 2009
programmer 	oscat
tested by	tobias

the function stair converts an anlog input signal to a staircase like output.
D is the step width for the output signal.
if D = 0 then the output follows the input without a chage.
(*@KEY@:END_DESCRIPTION*)
FUNCTION STAIR:REAL

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	D :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: STAIR
IEC_LANGUAGE: ST
*)
IF D > 0.0 THEN
	STAIR := DINT_TO_REAL(_REAL_TO_DINT(X / D)) * D;
ELSE
	STAIR := X;
END_IF;

(* revision history
hm	28 jan 2007		rev 1.0
	original version

hm	27 dec 2007		rev 1.1
	changed code for better performance

hm	6. jan 2008		rev 1.2
	further performance improvement

hm	26. oct. 2008		rev 1.3
	optimized code

hm	10. mar. 2009	rev 1.4
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
