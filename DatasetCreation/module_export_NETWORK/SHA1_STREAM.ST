(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CONVERT
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SHA1_STREAM

(*Group:Default*)


VAR_IN_OUT
	MODE :	INT;
	BUF :	oscat_aB0_63;
	SHA1 :	oscat_aB0_19;
	SIZE :	UDINT;
END_VAR


VAR_OUTPUT
	POS :	UDINT;
END_VAR


VAR
	hash :	oscat_aDW0_4;
	end :	UDINT;
	block :	UDINT;
	pad_1 :	BOOL;
	w :	oscat_sDW0_79;
	n :	INT;
	n1 :	INT;
	n2 :	INT;
	n3 :	INT;
	n4 :	INT;
	a :	DWORD;
	b :	DWORD;
	c :	DWORD;
	d :	DWORD;
	e :	DWORD;
	f :	DWORD;
	k :	DWORD;
	x :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: SHA1_STREAM
IEC_LANGUAGE: ST
*)

CASE MODE OF

1:	(* Initialisierung der Hash-Werte *)
	hash[0] := DWORD#16#67452301;
	hash[1] := DWORD#16#EFCDAB89;
	hash[2] := DWORD#16#98BADCFE;
	hash[3] := DWORD#16#10325476;
	hash[4] := DWORD#16#C3D2E1F0;

	(* Buffer initialisieren *)
	FOR n := 16 TO 79 DO
   		w[n] := DWORD#0;
	END_FOR;

	block := DWORD_TO_UDINT(SHR_DWORD(UDINT_TO_DWORD(SIZE),6)) + BOOL_TO_UDINT((UDINT_TO_BYTE(SIZE) AND BYTE#16#3F) > BYTE#55);	(* benötigte Blocks errechnen *)

	pad_1 := FALSE;
	POS := UDINT#0;
	End := SIZE;
	SIZE := MIN(UDINT#64,End);
	MODE := 2;

2:	FOR n := UDINT_TO_INT(SIZE) TO 63 DO (* Fuell-Bytes anhängen *)
		BUF[n] := BYTE#0;
	END_FOR;

	IF SIZE < UDINT#64 AND NOT pad_1 THEN
		BUF[SIZE] := BYTE#2#1000_0000;
		pad_1 := TRUE;
	END_IF;

	POS := POS + SIZE;
	SIZE := MIN(UDINT#64,End - POS);

	n := 0;	(* Byte-Array in DWORD-Array umkopieren *)
	FOR n4 := 0 TO 15 DO
		n1 := n + 1;
		n2 := n + 2;
		n3 := n + 3;
		w[n4] := DWORD_OF_BYTE(BUF[n],BUF[n1],BUF[n2],BUF[n3]);
		n := n + 4;
	END_FOR;

	IF block = UDINT#0 THEN (* am Ende des letzten Blocks die Datenlänge eintragen *)
		w[15] := SHL_DWORD(UDINT_TO_DWORD(End),3); (* Anzahl Datenbits eintragen *)
		MODE := 3;
	ELSE
		block := block - UDINT#1;
	END_IF;

	FOR n := 16 TO 79 DO (* erweitern der 16 32-bit-Worte auf 80 32-bit-Worte *)
		n1 := n - 3;
		n2 := n - 8;
		n3 := n - 14;
		n4 := n - 16;
		w[n] := ROL(w[n1] XOR w[n2] XOR w[n3] XOR w[n4],1);
	END_FOR;

	a := hash[0];
	b := hash[1];
	c := hash[2];
	d := hash[3];
	e := hash[4];

	FOR n := 0 TO 79 DO
		IF n <= 19 THEN
			f := (b AND c) OR (NOT(b) AND d);
			k := DWORD#16#5A827999;
		ELSIF n <= 39 THEN
			f := b XOR c XOR d;
			k := DWORD#16#6ED9EBA1;
		ELSIF n <= 59 THEN
			f := (b AND c) OR (b AND d) OR (c AND d);
			k := DWORD#16#8F1BBCDC;
		ELSE
			f := b XOR c XOR d;
			k := DWORD#16#CA62C1D6;
		END_IF;

		x := UDINT_TO_DWORD(DWORD_TO_UDINT(ROL(a,5)) + DWORD_TO_UDINT(f) + DWORD_TO_UDINT(e) + DWORD_TO_UDINT(k) + DWORD_TO_UDINT(w[n]));
		e := d;
		d := c;
		c := ROL(b,30);
		b := a;
		a := x;
	END_FOR;

	(* aktuelle Hash-Werte zum letzten Wert addieren *)
	hash[0] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[0]) + DWORD_TO_UDINT(a));
	hash[1] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[1]) + DWORD_TO_UDINT(b));
	hash[2] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[2]) + DWORD_TO_UDINT(c));
	hash[3] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[3]) + DWORD_TO_UDINT(d));
	hash[4] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[4]) + DWORD_TO_UDINT(e));

END_CASE;

IF MODE = 3 THEN
	n2 := 0;
	FOR n := 0 TO 4 DO (* konvertiere DWORD auf BYTE-Array *)
		FOR n1 := 0 TO 3 DO
			hash[n] := ROL(hash[n],8);
			SHA1[n2] := DWORD_TO_BYTE(hash[n]);
			n2 := n2 + 1;
		END_FOR;
	END_FOR;
END_IF;

(* revision history

hm	6. dec. 2009 rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
