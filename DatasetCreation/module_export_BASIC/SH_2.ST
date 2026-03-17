(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_PROCESSING
*)
(*@KEY@:DESCRIPTION*)
version 1.6	10. mar. 2009
programmer 	hugo
tested by	tobias

this sample and hold module samples an input every PT seconds.
this sample and hold also does avg and other calculations with the input data.
an average is calculated over N samples while for this calculation disc samples are discarded,
disc = 0 all samples are averaged,
if disc = 1 the lowest value is ignored,
if disc = 2 the lowest and highest values are ignored, 
and so on.....

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SH_2

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	PT :	TIME;
	N :	INT := INT#16;
	DISC :	INT;
END_VAR


VAR_OUTPUT
	OUT :	REAL;
	TRIG :	BOOL;
	AVG :	REAL;
	HIGH :	REAL;
	LOW :	REAL;
END_VAR


VAR
	M :	INT;
	buf :	oscat_arr_0_15;
	buf2 :	oscat_arr_0_15;
	last :	TIME;
	i :	INT;
	I2 :	INT;
	start :	INT;
	temp :	REAL;
	stop :	INT;
	tx :	TIME;
	d2 :	INT;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: SH_2
IEC_LANGUAGE: ST
*)
(* read system time *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
d2 := WORD_TO_INT(SHR(INT_TO_WORD(disc),1));

IF tx - last >= PT THEN
	last := tx;
	trig := TRUE;

	(* limit M to 0..16 *)
	M := LIMIT(1,N,16);

	(* edge detected lets take the sample *)
    i := M-1;
    WHILE (i>=1) DO
      i2 := i-1;
      buf2[i] := buf2[i2];
      i:=i-1;
    END_WHILE;

	buf2[0] := in;
	out := in;
	buf := buf2;

	(* sort the ARRAY lowest value AT 0 *)
	FOR start := 0 TO M - 2 DO
		FOR i := start+1 TO M - 1 DO
			IF buf[start] > buf[i] THEN
				temp := buf[start];
				buf[start] := buf[i];
				buf[i] := temp;
			END_IF;
		END_FOR;
	END_FOR;

	(* any calculation with the samples is here *)
	stop := M - 1 - d2;
	start := d2;
	IF NOT even(INT_TO_DINT(disc)) THEN start := start + 1; END_IF;
	avg := 0.0;
	FOR i := start TO stop DO avg := avg + buf[i]; END_FOR;
	avg := avg / INT_TO_REAL(stop - start +1);
	low := buf[start];
	high := buf[stop];
ELSE
	Trig := FALSE;
END_IF;

(* revision history
hm 20. jan. 2007	rev 1.1
	added input N to specify the amout of samples for average and high low calculations
	added trig output

hm 10. sep. 2007 	rev 1.2
	an error would be generated if N was set to 0, now n is forced to1 if set to 0.
	index was out of array.

hm	17. sep. 2007	rev 1.3
	replaced time() with t_plc_ms() for compatibility reasons

hm	6. jan. 2008	rev 1.4
	improved performance

hm	14. jun. 2008	rev 1.5
	set default for input N = 16

hm	10. mar. 2009	rev 1.6
	added type conversion for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
