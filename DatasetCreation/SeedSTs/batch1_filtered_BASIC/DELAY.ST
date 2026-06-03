(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.5	23. mar. 2009
programmer 	hugo
tested by	oscat

this function block delays input values by each programm cycle
after N+1 cycles the in value has shifted to the out.
N can be any alue from 0 .. 32
if n = 0 the input will be present on the output without a delay.
f N > 32 then the output will be delayed by 32 cycles.
any high on rst will load the buffer with in.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK DELAY

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	N :	INT;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
END_VAR


VAR
	buf :	oscat_delay_buf;
	i :	INT;
	init :	BOOL;
	stop :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: DELAY
IEC_LANGUAGE: ST
*)
stop := LIMIT(0,N,32) - 1;
IF rst OR NOT init THEN
	init := TRUE;
	FOR i := 0 TO stop DO buf[i] := in; END_FOR;
	out := in;
	i := 0;
ELSIF stop < 0 THEN
	out := in;
ELSE
	out := buf[i];
	buf[i] := in;
	i := INC1(i, N);
END_IF;


(* revision history
hm 1.10.2006		rev 1.1
	corrected error in buffer management

hm 19.1.2007		rev 1.2
	changed reset to load the value of in instead of 0

hm	27. oct. 2008	rev 1.3
	improved performance

hm	23. feb.2009	rev 1.4
	corrected an index problem

hm	23. mar. 2009	rev 1.5
	corrected non standard write to input N

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
