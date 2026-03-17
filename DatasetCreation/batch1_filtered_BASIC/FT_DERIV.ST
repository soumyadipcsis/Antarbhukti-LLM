(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.5	11. mar. 2009
programmer 	hugo
tested by	oscat

FT_deriv calculates the derivate over the signal "in" with Faktor "K".
a run input enables or stops the calculation, if left unconnected its true and therfore the calculation is executed.
if K is not specified the default is 1.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_DERIV

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	K :	REAL := 1.0;
	RUN :	BOOL := TRUE;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
END_VAR


VAR
	old :	REAL;
	tx :	UDINT;
	last :	UDINT;
	init :	BOOL;
	tc :	REAL;
	T_PLC_US :	T_PLC_US;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_DERIV
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_US();
tx:= T_PLC_US.T_PLC_US;
tc := UDINT_TO_REAL(tx - last);

(* init on firsat startup *)
IF NOT init THEN
	init := TRUE;
	old := in;
ELSIF run AND tc > 0.0 THEN
	out := (in - old) / tc * 1000000.0 * K;
	old := in;
ELSE
	out := 0.0;
END_IF;

last := tx;

(*
hm 3.1.2007			rev 1.1
	added init code for startup
	set the default for K to 1

hm	15. sep 2007	rev 1.2
	replaced Time() with T_PLC_US for compatibility and performance reasons
	increased accuracy and work in microseconds internally

hm 29 oct 2007	rev 1.3
	prohibit calculation when tx - last = 0 to avoid division by 0 and increase accuracy on fast systems

hm	6. nov. 2008	rev 1.4
	improved performance

hm	11. mar. 2009	rev 1.5
	inproved code
*)








(* read system time *)
T_PLC_US();
tx:= T_PLC_US.T_PLC_US;

(* init on firsat startup *)
IF NOT init THEN
	init := TRUE;
ELSIF run AND tx - last > UDINT#0 THEN
	out := (in - old) / UDINT_TO_REAL(tx - last) * 1000000.0 * K;
ELSE
	out := 0.0;
END_IF;
old := in;
last := tx;


(*
hm 3.1.2007			rev 1.1
	added init code for startup
	set the default for K to 1

hm	15. sep 2007	rev 1.2
	replaced Time() with T_PLC_US for compatibility and performance reasons
	increased accuracy and work in microseconds internally

hm 29 oct 2007	rev 1.3
	prohibit calculation when tx - last = 0 to avoid division by 0 and increase accuracy on fast systems

hm	3. nov. 2008	rev 1.4
	improved performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
