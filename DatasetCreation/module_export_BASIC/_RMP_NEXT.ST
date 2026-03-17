(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SIGNAL_GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.4	18. jul. 2009
programmer 	hugo
tested by	oscat


_RMP_NEXT  will generate a ramp output following the input IN.
on a rising ramp the output will stop as soon as it has surpassed the input in, and on a falling ramp it will stop when out is smaller than in.
a lockout time T_L will be added between up and down direction.


(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _RMP_NEXT

(*Group:Default*)


VAR_INPUT
	E :	BOOL := TRUE;
	IN :	BYTE;
	TR :	TIME;
	TF :	TIME;
	TL :	TIME;
END_VAR


VAR_OUTPUT
	DIR :	BOOL;
	UP :	BOOL;
	DN :	BOOL;
END_VAR


VAR_IN_OUT
	OUT :	BYTE;
END_VAR


VAR
	rmx :	_RMP_B;
	dirx :	TREND_DW;
	t_lock :	TP;
	xen :	BOOL;
	xdir :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: _RMP_NEXT
IEC_LANGUAGE: ST
*)
dirx(X := BYTE_TO_DWORD(in));

t_lock(in := FALSE, pt := TL);

IF dirx.TU AND (OUT < IN) THEN
	IF NOT xdir AND xen THEN t_lock(in := TRUE); END_IF;
	xen := TRUE;
	xdir := TRUE;
ELSIF dirx.TD AND (OUT > IN) THEN
	IF xdir AND xen THEN t_lock(in := TRUE); END_IF;
	xen := TRUE;
	xdir := FALSE;
ELSIF xen THEN
	IF (xdir AND (out >= in)) OR (NOT xdir AND (out <= in)) THEN
		xen := FALSE;
		IF tl > t#0s THEN t_lock(IN := TRUE); END_IF;
	END_IF;
END_IF;

IF NOT t_lock.Q AND xen THEN
	UP := XDIR;
	DIR := XDIR;
	DN := NOT XDIR;
ELSE
	UP := FALSE;
	DN := FALSE;
END_IF;

rmx(rmp := OUT, E := E AND (UP OR DN) , dir := DIR, tr := SEL(dir, TF, TR));
OUT := rmx.RMP;


(* revison history
hm	23. nov. 2008	rev 1.0
	original version

hm	24. jan. 2009	rev 1.1
	deleted unused vars tmp1, tmp2

hm	20. feb. 2009	rev 1.2
	improved algorithm
	added TL

hm	9. mar. 2009	rev 1.3
	input E was ignored
	removed double assignments

hm	18. jul. 2009	rev 1.4
	improved performance

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
