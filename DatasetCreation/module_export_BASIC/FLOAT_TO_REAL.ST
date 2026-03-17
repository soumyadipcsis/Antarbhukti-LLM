(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	23. oct. 2008
programmer 	hugo
tested by	oscat

FLOAT_TO_REAL converts a string to a REAL.
the function ignores all wrong characters.
the comma can be , or .
the exponent has to start with capital E or lowercase e .
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK FLOAT_TO_REAL

(*Group:Default*)


VAR_INPUT
	FLT :	oscat_STRING20;
END_VAR


VAR_OUTPUT
	FLOAT_TO_REAL :	REAL;
END_VAR


VAR
	i :	INT;
	X :	BYTE;
	sign :	INT := 1;
	stop :	INT;
	tmp :	DINT;
	d :	INT;
	DEC_TO_INT :	DEC_TO_INT;
	CODE :	CODE;
END_VAR


(*@KEY@: WORKSHEET
NAME: FLOAT_TO_REAL
IEC_LANGUAGE: ST
*)
sign := 1;
d := 0;
stop := LEN(FLT);
tmp := DINT#0;

(* we first check for sign and exit if first number or dot is reached *)
FOR i := 1 TO stop DO
    CODE(STR:=FLT,POS:=i);
    X := CODE.CODE;
	IF X > BYTE#47 AND X < BYTE#58 OR X = BYTE#46 THEN
		EXIT;
	ELSIF X = BYTE#45 THEN
		(* code 45 is sign *)
		sign := -1;
	END_IF;
END_FOR;

(* now we scan numbers till end or dot or E is reached *)
FOR i := i TO stop DO
    CODE(STR:=FLT,POS:=i);
    X := CODE.CODE;
	IF X = BYTE#44 OR X = BYTE#46 OR X = BYTE#69 OR X = BYTE#101 THEN
		EXIT;
	(* calculate the value of the digit *)
	ELSIF X > BYTE#47 AND x < BYTE#58 THEN
		tmp := tmp * DINT#10 + _BYTE_TO_DINT(X) - DINT#48;
	END_IF;
END_FOR;

(* process the portion after the comma if comma or dot is reached exit if exponent starts *)
IF x = BYTE#44 OR X = BYTE#46 THEN
	FOR i := i + 1 TO stop DO
        CODE(STR:=FLT,POS:=i);
        X := CODE.CODE;
		IF X = BYTE#69 OR X = BYTE#101 THEN
			EXIT;
		ELSIF x > BYTE#47 AND x < BYTE#58 THEN
			tmp := tmp * DINT#10 + _BYTE_TO_DINT(X) - DINT#48;
			d := d - 1;
		END_IF;
	END_FOR;
END_IF;

(* process exponent if present *)
IF (X = BYTE#69 OR X = BYTE#101) AND i<=stop THEN
    DEC_TO_INT(DEC:=MID(FLT, MIN(stop - i,10),MIN(stop,i+1)));
    d := d + DEC_TO_INT.DEC_TO_INT;


(*    DEC_TO_INT(DEC:=RIGHT(FLT, MIN(stop - i,10)));
    d := d + DEC_TO_INT.DEC_TO_INT;*)
END_IF;

FLOAT_TO_REAL :=  EXPN(10.0, d) * DINT_TO_REAL(TMP * INT_TO_DINT(SIGN));

(* revision histroy
hm	22. jun. 2008	rev 1.0
	original release

hm	2. oct. 2008	rev 1.1
	fixed an error, characters 8 and 9 would not be converted

hm	22. oct. 2008	rev 1.2
	last fix was not done correctly

hm	23. oct. 2008	rev 1.3
	optimzed code
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
