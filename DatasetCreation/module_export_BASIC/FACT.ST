(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.5	26. mar. 2011
programmer 	hugo
tested by	tobias

this function calculates the factorial of x

if the input is negative or higher then 12 the output will be -1.

(*@KEY@:END_DESCRIPTION*)
FUNCTION FACT:DINT

(*Group:Default*)


VAR_INPUT
	X :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FACT
IEC_LANGUAGE: ST
*)
CASE X OF
00: FACT := DINT#1;
01: FACT := DINT#1;
02: FACT := DINT#2;
03: FACT := DINT#6;
04: FACT := DINT#24;
05: FACT := DINT#120;
06: FACT := DINT#720;
07: FACT := DINT#5040;
08: FACT := DINT#40320;
09: FACT := DINT#362880;
10: FACT := DINT#3628800;
11: FACT := DINT#39916800;
12: FACT := DINT#479001600;
ELSE
    FACT := DINT#-1;
END_CASE;

(* revision history
hm 4.3.2007		rev 1.1
	changed a critical error where while loop was indefinite.

hm	10.12.2007	rev 1.2
	start value for i has changed to 2 for better performance

hm	10. mar 2008	rev 1.3
	changed output of fact to dint to allow bigger values

hm	27. oct. 2008	rev 1.4
	optimized code

hm	26. mar. 2011	rev 1.5
	using array math.facts
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
