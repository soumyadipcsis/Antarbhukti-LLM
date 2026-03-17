(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16 sep 2007
programmer 	oscat
tested BY	oscat

this signal generator generates a random output. The signal is defined by period time (PT), 
amplitude (AM), offset (OS).
The Output waveform will have its max peak at AM/2 + OS and its minimum peak at -AM/2 + OS. 
The period time PT defines how often the output signal will jump to a new randow value.
The Output Q will be true for one cycle anytime the output OUT has changed
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK GEN_RDM

(*Group:Default*)


VAR_INPUT
	PT :	TIME;
	AM :	REAL := REAL#1.0;
	OS :	REAL;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	Out :	REAL;
END_VAR


VAR
	tx :	TIME;
	last :	TIME;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
	FB_rdm :	rdm;
END_VAR


(*@KEY@: WORKSHEET
NAME: GEN_RDM
IEC_LANGUAGE: ST
*)
(* read system time and prepare input data *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) - last;

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

	(* generate output signal *)
    FB_rdm(last:=0.0);
	out := am * (FB_rdm.RDM - 0.5) + os;
	q := TRUE;
ELSE
	q := FALSE;
END_IF;

(* revision history

hm	7.2.2007		rev 1.0
	original version

hm	16.9.2007		rev 1.1
	changes time() to T_plc_ms() for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
