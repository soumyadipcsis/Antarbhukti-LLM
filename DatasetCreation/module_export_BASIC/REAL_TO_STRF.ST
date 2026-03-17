(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.8	2. jan 2012
programmer 	hugo
tested by	oscat

Real_to_strf converts a Real to a fixed length String.
the string will be filles with zeroes to achieve the fixed length N after the decimal separator.
the input parameter specifies the decimal separator to be used in the output string.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REAL_TO_STRF

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	N :	INT;
	D :	oscat_STRING1;
END_VAR


VAR_OUTPUT
	REAL_TO_STRF :	oscat_STRING20;
END_VAR


VAR
	st_tmp :	oscat_STRING20;
	i :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: REAL_TO_STRF
IEC_LANGUAGE: ST
*)
(* LIMIT N to 0 .. 7 *)
N := LIMIT(0,N,7);
(* round the input to N digits and convert to string *)
REAL_TO_STRF := DINT_TO_STRING(_REAL_TO_DINT(ABS(in) * EXP10(INT_TO_REAL(N))),'%d');
(* add zeroes in front to make sure sting is at least 8 digits long *)
FOR i := LEN(REAL_TO_STRF) TO N DO
	st_tmp := REAL_TO_STRF;	
	REAL_TO_STRF := CONCAT('0', st_tmp);
END_FOR;
(* add a dot if n > 0 *)
IF n > 0 THEN REAL_TO_STRF := INSERT(REAL_TO_STRF, D, LEN(REAL_TO_STRF) - N); END_IF;
(* add a minus sign if in is negative *)
IF in < 0.0 THEN st_tmp := REAL_TO_STRF; REAL_TO_STRF := CONCAT('-', st_tmp); END_IF;

(* revision history
hm	26 jan 2007	rev 1.0
	original version

hm	20. nov. 2007	rev 1.1
	when N=0 ther will be no dot at the end of the string.

hm	15. dec. 2007	rev 1.2
	changed code for better performance

hm	4. mar. 2008	rev 1.3
	result is now rounded instead of trunc

hm	20. mar. 2008	rev 1.4
	changed trunc to real_to_dint because trunc was generating wrong values on wago 842

hm	29. mar. 2008	rev 1.5
	changed STRING to STRING(20)

hm	4. apr. 2008	rev 1.6
	added variable O to avoid an error uner CoDeSys SP PLCWinNT V2.4

hm	27. feb. 2009	rev 1.7
	added a missing zero for IN < 1

hm 2. jan 2012	rev 1.8
	added input parameter D to specify decimal separator
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
