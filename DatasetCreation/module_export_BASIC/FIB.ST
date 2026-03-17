(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.3	26. mar. 2008
programmer 	hugo
tested by	tobias

this function calculates the fibonacci sequence
(*@KEY@:END_DESCRIPTION*)
FUNCTION FIB:DINT

(*Group:Default*)


VAR_INPUT
	X :	INT;
END_VAR


VAR
	t1 :	DINT;
	t2 :	DINT;
	X_tmp :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: FIB
IEC_LANGUAGE: ST
*)
t1 := DINT#0;
t2 := DINT#0;
X_tmp := X;
IF X_tmp < 0 OR X_tmp > 46 THEN
	FIB := DINT#-1;
ELSIF X_tmp < 2 THEN
	FIB := INT_TO_DINT(X_tmp);
	RETURN;
ELSE
	(* the fibonacci number is the sum of the two suceeding fibonaci numbers *)
	(* we store the numbers alternatively in t1 and t2 depending on pt *)
	t2 := DINT#1;
	WHILE X_tmp > 3 DO
		X_tmp := X_tmp - 2;
		t1 := t1 + t2;
		t2 := t1 + t2;
	END_WHILE;
	IF X_tmp > 2 THEN t1 := t1 + t2; END_IF;
	fib := t1 + t2;
END_IF;

(* alternative code for very big numbers

IF X < 31 THEN
	fib := 0.4472136 * (expn(1.618034,X) - expn(-0.618034,X));
ELSE
	fib := 0.4472133 * expn(1.618034,X);
END_IF;

*)

(* revision history
hm		27. dec 2007	rev 1.0
	original version

hm		2. jan 2008	rev 1.1
	deleted unused variable pt

hm		10. mar 2008	rev 1.2
	changed output to dint instead of real

hm		26. mar. 2008	rev 1.3
	function now returns -1 for input < 0 or > 46

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
