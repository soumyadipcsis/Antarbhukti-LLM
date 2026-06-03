(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	oscat
tested by	tobias

Ain1 converts signals from A/D converters or other digital sources to an internal real value.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK AIN1

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
	SIGN_BIT :	INT := 255;
	ERROR_BIT :	INT := 255;
	ERROR_CODE_EN :	BOOL := FALSE;
	ERROR_CODE :	DWORD;
	OVERFLOW_BIT :	INT := 255;
	OVERFLOW_CODE_EN :	BOOL;
	OVERFLOW_CODE :	DWORD;
	BIT_0 :	INT;
	BIT_N :	INT := 31;
	OUT_MIN :	REAL;
	OUT_MAX :	REAL := 10.0;
	CODE_MIN :	DWORD;
	CODE_MAX :	DWORD := DWORD#16#FFFFFFFF;
	ERROR_OUTPUT :	REAL;
	OVERFLOW_OUTPUT :	REAL := 10.0;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
	SIGN :	BOOL;
	ERROR :	BOOL;
	OVERFLOW :	BOOL;
END_VAR


VAR
	tB :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: AIN1
IEC_LANGUAGE: ST
*)
(* extract error bit *)
error := ((SHR_DWORD(in,error_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (error_code_en AND error_code = in);
IF error THEN
	out := error_output;
	RETURN;
END_IF;

(* strip off the data input *)
tb := SHR_DWORD(SHL_DWORD(in, 31 - bit_N), 31 - bit_N + Bit_0);

(* extract overflow bit *)
overflow := ((SHR_DWORD(in,overflow_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (overflow_code_en AND overflow_code = in) OR (tb < code_min OR tb > code_max);
IF overflow THEN
	out := overflow_output;
	RETURN;
END_IF;

(* extract sign bit *)
sign := (SHR_DWORD(in,sign_bit) AND DWORD#16#0000_0001) = DWORD#1;

(* convert in to out *)
out := (UDINT_TO_REAL(DWORD_TO_UDINT(tb) - DWORD_TO_UDINT(code_min)) * (out_max - out_min) / UDINT_TO_REAL(DWORD_TO_UDINT(code_max) - DWORD_TO_UDINT(code_min)) + out_min);
IF sign THEN out := out * -1.0; END_IF;



(* revision history
hm	23. feb 2008	rev 1.0
	original version

hm	16. mar 2008	rev 1.1
	added type conversions to avoid warnngs under codesys 30

hm	22. apr. 2008	rev 1.2
	corrected error in formula when code_min was set
	corrected error when sign bit was used
	optimized code for better performance

hm	10. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)












(* extract error bit *)
error := ((SHR_DWORD(in,error_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (error_code_en AND error_code = in);
IF error THEN
	out := error_output;
	RETURN;
END_IF;

(* strip off the data input *)
tb := SHR_DWORD(SHL_DWORD(in, 31 - bit_N), 31 - bit_N + Bit_0);

(* extract overflow bit *)
overflow := ((SHR_DWORD(in,overflow_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (overflow_code_en AND overflow_code = in) OR (tb < code_min OR tb > code_max);
IF overflow THEN
	out := overflow_output;
	RETURN;
END_IF;

(* extract sign bit *)
sign := (SHR_DWORD(in,sign_bit) AND DWORD#16#0000_0001) = DWORD#1;

(* convert in to out *)
out := (UDINT_TO_REAL(DWORD_TO_UDINT(tb) - DWORD_TO_UDINT(code_min)) * (out_max - out_min) / UDINT_TO_REAL(DWORD_TO_UDINT(code_max) - DWORD_TO_UDINT(code_min)) + out_min);
IF sign THEN out := out * - 1.0; END_IF;

(* revision history
hm	23. feb 2008	rev 1.0
	original version

hm	16. mar 2008	rev 1.1
	added type conversions to avoid warnngs under codesys 30

hm	22. apr. 2008	rev 1.2
	corrected error in formula when code_min was set
	corrected error when sign bit was used
	optimized code for better performance

hm	10. mar. 2009	rev 1.3
	real constants updated to new systax using dot

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
