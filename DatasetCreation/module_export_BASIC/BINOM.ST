(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	25. oct. 2008
programmer 	hugo
tested by	tobias

this function calculates the binomialkoefficient (N over k)
(*@KEY@:END_DESCRIPTION*)
FUNCTION BINOM:INT

(*Group:Default*)


VAR_INPUT
	N :	INT;
	K :	INT;
END_VAR


VAR
	i :	INT;
	N2 :	INT;
	K2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BINOM
IEC_LANGUAGE: ST
*)
K2 := K;
N2 := N;
IF 2 * K2 > N2 THEN
	K2 := N2 - K2;
END_IF;
IF K2 > N2 THEN
	RETURN;
ELSIF K2 = 0 OR K2 = N2 THEN
	BINOM := 1;
ELSIF K2 = 1 THEN
	BINOM := N2;
ELSE
	BINOM := N2;
	N2 := N2 + 1;
	FOR i := 2 TO K2 DO
		BINOM := BINOM * (N2 - i) / i;
	END_FOR;
END_IF;

(*
binomialkoeffizient(n, k)
1  wenn k = 0 return 1
2  wenn 2k > n
3      dann führe aus ergebnis \leftarrow binomialkoeffizient(n, n-k)
4  sonst führe aus ergebnis \leftarrow n
5          von i \leftarrow 2 bis k
6              führe aus ergebnis \leftarrow ergebnis \cdot (n + 1 - i)
7                        ergebnis \leftarrow ergebnis : i
8  return ergebnis
*)



(* revision history
hm	25. oct. 2008	rev 1.0
	original version


*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
