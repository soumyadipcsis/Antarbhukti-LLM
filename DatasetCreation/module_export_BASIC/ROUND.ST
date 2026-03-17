(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.4	16. mar 2008
programmer 	hugo
tested by	tobias

this function rounds a real down to n digits behind the comma.
round(3.1415,1) = 3.1
(*@KEY@:END_DESCRIPTION*)
FUNCTION ROUND:REAL

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	N :	INT;
END_VAR


VAR
	X :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ROUND
IEC_LANGUAGE: ST
*)
IF N < 4 THEN
	IF N < 2 THEN
		IF N = 0 THEN X := 1.0; ELSE X := 10.0; END_IF;
	ELSE
		IF N = 2 THEN X := 100.0; ELSE X := 1000.0; END_IF;
	END_IF;
ELSE
	IF N < 6 THEN
		IF N = 4 THEN X := 10000.0; ELSE X := 100000.0; END_IF;
	ELSE
		IF N = 6 THEN X := 1000000.0; ELSE X := 10000000.0; END_IF;
	END_IF;
END_IF;

ROUND := DINT_TO_REAL(_REAL_TO_DINT(in * X)) / X;

(*
IF in >= 0 THEN
	ROUND := TRUNC(in * X + 0.5) / X;
ELSE
	ROUND := TRUNC(in * X - 0.5) / X;
END_IF;
*)

(* revision history
hm	1. sep 2006	rev 1.0
	original version

hm	2. dec 2007	rev 1.1
	changed code for better performance

hm	8. jan 2008	rev 1.2
	further improvement in performance

hm 11. mar. 2008	rev 1.3
	corrected an error with negative numbers
	use real_to_dint instead of trunc

hm	16. mar 2008	rev 1.4
	added type conversion to avoid warning under codesys 3.0
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
