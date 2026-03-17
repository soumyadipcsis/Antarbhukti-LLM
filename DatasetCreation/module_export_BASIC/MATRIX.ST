(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.OTHER
*)
(*@KEY@:DESCRIPTION*)
version 1.3	26 oct. 2008
programmer 	hugo
tested by	oscat

MATRIX is a matrix keyboard encoder for 4 rows and up to 5 columns.
matrix can send a code while a key is pressed and it sends another code while a key is released when the setup variable 'release' is set to true.
the setup variable release is false the code is only sent when the key is pressed.
the output byte holds the 5 columns in the lowest bits 0..2  and the row number in bits 4..6, while bit 7 is true for a key pressed and false for a key released.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MATRIX

(*Group:Default*)


VAR_INPUT
	X1 :	BOOL;
	X2 :	BOOL;
	X3 :	BOOL;
	X4 :	BOOL;
	X5 :	BOOL;
	RELEASE :	BOOL;
END_VAR


VAR_OUTPUT
	CODE :	BYTE;
	TP :	BOOL;
	Y1 :	BOOL := TRUE;
	Y2 :	BOOL;
	Y3 :	BOOL;
	Y4 :	BOOL;
END_VAR


VAR
	line :	BYTE;
	X :	oscat_arb_0_3;(*scan line inputs*)
	L :	oscat_arb_0_3;(*scan line status*)
	i :	INT;
	temp :	BYTE;
	temp2 :	BYTE;
	L_temp :	BYTE;
	temp_bit :	BOOL;
	in_temp :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MATRIX
IEC_LANGUAGE: ST
*)
TP := FALSE;
code := BYTE#0;

(* read scan lines *)
in_temp := _BYTE_TO_INT(line);
temp := X[in_temp];  (* X[LINE] umkopieren *)

temp:=BIT_LOAD_B(temp,X1,0); (* X[line].0 := X1; *)
temp:=BIT_LOAD_B(temp,X2,1); (* X[line].1 := X2; *)
temp:=BIT_LOAD_B(temp,X3,2); (* X[line].2 := X3; *)
temp:=BIT_LOAD_B(temp,X4,3); (* X[line].3 := X4; *)
temp:=BIT_LOAD_B(temp,X5,4); (* X[line].4 := X5; *)

X[in_temp] := temp; (* X[LINE] zurückkopieren *)

(* compare for change *)
FOR i := 0 TO 3 DO
	IF X[i] <> L[i] THEN
		(* scan line information has changed code need to be found and generated *)
		temp   := x[i] XOR L[i];
        temp2  := X[i];
        L_temp := L[i];

        IF BIT_OF_DWORD(BYTE_TO_DWORD(temp),0) THEN (* temp.X0 *)
			code := BYTE#1;
            temp_bit := BIT_OF_DWORD(BYTE_TO_DWORD(temp2),0);   (* X[i].X0 *)
            code := BIT_LOAD_B(code,temp_bit,7);     			(* code.X7 *)
            L_temp := BIT_LOAD_B(L_temp,temp_bit,0); 			(* L[i].X0 *)
		ELSIF BIT_OF_DWORD(BYTE_TO_DWORD(temp),1) THEN          (* temp.X1 *)
			code := BYTE#2;
            temp_bit := BIT_OF_DWORD(BYTE_TO_DWORD(temp2),1);   (* X[i].X1 *)
            code := BIT_LOAD_B(code,temp_bit,7);     			(* code.X7 *)
            L_temp := BIT_LOAD_B(L_temp,temp_bit,1); 			(* L[i].X1 *)
		ELSIF BIT_OF_DWORD(BYTE_TO_DWORD(temp),2) THEN          (* temp.X2 *)
			code := BYTE#3;
            temp_bit := BIT_OF_DWORD(BYTE_TO_DWORD(temp2),2);   (* X[i].X2 *)
            code := BIT_LOAD_B(code,temp_bit,7);     			(* code.X7 *)
            L_temp := BIT_LOAD_B(L_temp,temp_bit,2); 			(* L[i].X2 *)
		ELSIF BIT_OF_DWORD(BYTE_TO_DWORD(temp),3) THEN          (* temp.X3 *)
			code := BYTE#4;
            temp_bit := BIT_OF_DWORD(BYTE_TO_DWORD(temp2),3);   (* X[i].X3 *)
            code := BIT_LOAD_B(code,temp_bit,7);     			(* code.X7 *)
            L_temp := BIT_LOAD_B(L_temp,temp_bit,3); 			(* L[i].X3 *)
		ELSIF BIT_OF_DWORD(BYTE_TO_DWORD(temp),4) THEN          (* temp.X4 *)
			code := BYTE#5;
            temp_bit := BIT_OF_DWORD(BYTE_TO_DWORD(temp2),4);   (* X[i].X4 *)
            code := BIT_LOAD_B(code,temp_bit,7);     			(* code.X7 *)
            L_temp := BIT_LOAD_B(L_temp,temp_bit,4); 			(* L[i].X4 *)
		END_IF;
        L[i] := L_temp;
		TP := TRUE;
        code := (code AND BYTE#2#1000_1111) OR SHL(LINE AND BYTE#2#0000_0111,4);
        (* obere zeile enspricht: Code.X4 := Line.X0; /  Code.X5 := Line.X1; / Code.X6 := Line.X2; *)

		(* check if release codes need to be killed *)
		IF NOT release AND code < BYTE#127 THEN
			code := BYTE#0;
			TP := FALSE;
		END_IF;
        EXIT;
	END_IF;
END_FOR;

(* increment scan line every cycle *)
line := INT_TO_BYTE(_BYTE_TO_INT(line) + 1) AND BYTE#2#0000_0011;
temp := SHL(BYTE#1,_BYTE_TO_INT(line));

Y1 := BIT_OF_DWORD(BYTE_TO_DWORD(temp),0); (* temp.0 *)
Y2 := BIT_OF_DWORD(BYTE_TO_DWORD(temp),1); (* temp.1 *)
Y3 := BIT_OF_DWORD(BYTE_TO_DWORD(temp),2); (* temp.2 *)
Y4 := BIT_OF_DWORD(BYTE_TO_DWORD(temp),3); (* temp.3 *)

(* revision history
hm		10.6.2007	rev 1.0		
	original version 


hm		11.9.2007	rev 1.1		
	deleted unused variables k and old_code

hm		23.12.2007	rev 1.2
	added exit statement in for loop instead of i:=5

hm		26. oct. 2008	rev 1.3
	code optimized

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
