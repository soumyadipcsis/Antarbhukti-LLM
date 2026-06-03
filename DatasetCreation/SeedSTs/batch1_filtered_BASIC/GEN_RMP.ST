(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.4	10. mar. 2009
programmer 	oscat
tested BY	oscat

this signal generator generates a ramp wave output. The ramp wave signal is defined by period time (PT), 
amplitude (AM), offset (OS) and a specific delay for the output signal (DL).
The Output waveform will have its minimum peak at OS and its maximum peak at AM + OS. 
The delay input can delay a signal up to PT, this can be useful to synchronize different generators 
and generate interleaving signals.
in addition to the analog output Out there is a second boolean output Q with is true for one cycle when the ramp starts.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK GEN_RMP

(*Group:Default*)


VAR_INPUT
	PT :	TIME := T#1s;
	AM :	REAL := REAL#1.0;
	OS :	REAL;
	DL :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	OUT :	REAL;
END_VAR


VAR
	tx :	TIME;
	last :	TIME;
	init :	BOOL;
	temp :	REAL;
	ltemp :	REAL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: GEN_RMP
IEC_LANGUAGE: ST
*)
(* read system time and prepare input data *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) - last;
DL := modR(dl,1.0);
IF dl < 0.0 THEN dl := 1.0 - dl; END_IF;

(* init section *)
IF NOT init THEN
	init := TRUE;
	last := tx;
	tx := t#0s;
END_IF;

(* add last if one cycle is finished *)
IF tx >= pt THEN
	last := last + pt;
	tx := tx - pt;
END_IF;

(* generate sine wave *)
ltemp := temp;
IF pt > t#0s THEN temp := fract(TIME_TO_REAL(tx + multime(pt, dl)) / TIME_TO_REAL(pt)); END_IF;
out := am * temp + os;

(* boolean output Q *)
Q := temp < ltemp;

(* revision history
hm	3. mar 2007		rev 1.0
	original version

hm	17 sep 2007		rev 1.1
	replaced time() with t_plc_ms for compatibilitx reasons

hm	27. nov 2007	rev 1.2
	avoid divide by 0 when pt = 0

ks	26. oct. 2008	rev 1.3
	code optimization

hm	10. mar. 2009	rev 1.4
	changed real constants to use dot syntax
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
