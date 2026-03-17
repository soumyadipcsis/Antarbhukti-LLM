(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	16. mar. 2008
programmer 	hugo
tested by		tobias

parset selects on of 4 parameter sets adressed by the inputs A0 and A1. if TC is specified, the change of the outputs
is ramped by the time tc
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PARSET

(*Group:Default*)


VAR_INPUT
	A0 :	BOOL;
	A1 :	BOOL;
	X01 :	REAL;
	X02 :	REAL;
	X03 :	REAL;
	X04 :	REAL;
	X11 :	REAL;
	X12 :	REAL;
	X13 :	REAL;
	X14 :	REAL;
	X21 :	REAL;
	X22 :	REAL;
	X23 :	REAL;
	X24 :	REAL;
	X31 :	REAL;
	X32 :	REAL;
	X33 :	REAL;
	X34 :	REAL;
	TC :	TIME;
END_VAR


VAR_OUTPUT
	P1 :	REAL;
	P2 :	REAL;
	P3 :	REAL;
	P4 :	REAL;
END_VAR


VAR
	X :	oscat_parset;
	S1 :	REAL;
	S2 :	REAL;
	S3 :	REAL;
	S4 :	REAL;
	tx :	UDINT;
	last :	UDINT;
	start :	BOOL;
	set :	BYTE;
	set2 :	INT;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: PARSET
IEC_LANGUAGE: ST
*)
(* read system_time *)
T_PLC_MS();
tx:= T_PLC_MS.T_PLC_MS;

(* init sequence *)
IF NOT init THEN
    set:=BIT_LOAD_B(set,NOT A0,0); (* set.X0 := NOT A0; *)
	init := TRUE;
	X[0][1] := X01;
	X[0][2] := X02;
	X[0][3] := X03;
	X[0][4] := X04;
	X[1][1] := X11;
	X[1][2] := X12;
	X[1][3] := X13;
	X[1][4] := X14;
	X[2][1] := X21;
	X[2][2] := X22;
	X[2][3] := X23;
	X[2][4] := X24;
	X[3][1] := X31;
	X[3][2] := X32;
	X[3][3] := X33;
	X[3][4] := X34;
	P1 := X01;
	P2 := X02;
	P3 := X03;
	P4 := X04;
END_IF;

(* check for input change *)
IF (A0 XOR BIT_OF_DWORD(BYTE_TO_DWORD(set),0)) OR (A1 XOR BIT_OF_DWORD(BYTE_TO_DWORD(set),1)) THEN  (* set.X0  ,  set.X1 *) 
	(* a new set is selected *)
    set := BIT_LOAD_B(set,A0,0); (* set.X0 := A0; *)
    set := BIT_LOAD_B(set,A1,1); (* set.X1 := A1; *)

	IF tc > t#0s THEN
		start := TRUE;
		last := tx;
		(* save the step speed for the output changes in S *)
		set2 := _BYTE_TO_INT(set);
		S1 := (X[set2][1] - P1)/TIME_TO_REAL(tc);
		S2 := (X[set2][2] - P2)/TIME_TO_REAL(tc);
		S3 := (X[set2][3] - P3)/TIME_TO_REAL(tc);
		S4 := (X[set2][4] - P4)/TIME_TO_REAL(tc);
	END_IF;
ELSIF start AND tx - last < TIME_TO_UDINT(tc) THEN
	(* ramp the outputs to the new value *)
	set2 := _BYTE_TO_INT(set);
	P1 := X[set2][1] - S1*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(tx + last));
	P2 := X[set2][2] - S2*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(tx + last));
	P3 := X[set2][3] - S3*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(tx + last));
	P4 := X[set2][4] - S4*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(tx + last));
ELSE
	(* make sure outputs match the correct set values *)
	set2 := _BYTE_TO_INT(set);
	start := FALSE;
	P1 := X[set2][1];
	P2 := X[set2][2];
	P3 := X[set2][3];
	P4 := X[set2][4];
END_IF;

(* revision history
hm	2.11.2007		rev 1.0
	original version

hm	16. mar. 2008	rev 1.1
	added type conversions to avoid warnings under codesys 3.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
