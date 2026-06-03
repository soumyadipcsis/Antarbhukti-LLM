(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.0	1 sep 2006
programmer 	hugo
tested by	tobias

this function block stores the min and max value of an input signal.
when rst is true the mn and mx outputs are set to the in value.
when a rst is never active the function autoresets to the in value at startup.
since the input might not be present at first cycle the mn and mx are set during second cycle.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_MIN_MAX

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	MX :	REAL;
	MN :	REAL;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_MIN_MAX
IEC_LANGUAGE: ST
*)
IF (rst = TRUE) OR (init = FALSE) THEN
  mn := in;
  mx := in;
  init := TRUE;
ELSIF (in < mn) THEN
  mn := in;
ELSIF (in > mx) THEN
  mx := in;
END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
