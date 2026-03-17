(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.2	14. mar. 2009
programmer 	hugo
tested by	tobias

4 bit shift register with reset up / down direction input
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SHR_4UDE

(*Group:Default*)


VAR_INPUT
	SET :	BOOL;
	D0 :	BOOL;
	D3 :	BOOL;
	CLK :	BOOL;
	DN :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
END_VAR


VAR
	trig :	R_TRIG;
END_VAR


(*@KEY@: WORKSHEET
NAME: SHR_4UDE
IEC_LANGUAGE: ST
*)
(* trig.Q signals a rising edge on clk *)
trig(clk := clk);

IF set OR rst THEN
	Q0 := NOT RST;
	Q1 := Q0;
	Q2 := Q0;
	Q3 := Q0;
ELSIF trig.Q THEN
	IF dn THEN
		Q0 := Q1;
		Q1 := Q2;
		Q2 := Q3;
		Q3 := D3;
	ELSE
		Q3 := Q2;
		Q2 := Q1;
		Q1 := Q0;
		Q0 := D0;
	END_IF;
END_IF;



(* revision history
hm	4. aug. 2006	rev 1.0
	original version

hm	25. oct. 2008	rev 1.1
	optimized code

hm	14. mar. 2009	rev 1.2
	removed double assignments

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
