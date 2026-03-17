(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONTROL
*)
(*@KEY@:DESCRIPTION*)
version 1.0	3. jun 2008
programmer 	hugo
tested by	tobias

FT_PD is a PD controller.
The PD controller works according to the fomula Y = KP *(IN + DERIV(e) ).
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FT_PDT1

(*Group:Default*)


VAR_INPUT
	IN :	REAL;
	KP :	REAL := 1.0;
	TV :	REAL := 1.0;
	T1 :	REAL := 1.0;
END_VAR


VAR_OUTPUT
	Y :	REAL;
END_VAR


VAR
	diff :	FT_DERIV;
	TP :	FT_PT1;
END_VAR


(*@KEY@: WORKSHEET
NAME: FT_PDT1
IEC_LANGUAGE: ST
*)
(* run differentiator *)
diff(IN := IN, K := TV);

(* Run PT1 filter *)
tp(in := diff.out, T := REAL_TO_TIME(T1));

(* combine both values *)
Y := KP * (tp.out + IN);

(* revision history
hm 	3. jun. 2008 	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
