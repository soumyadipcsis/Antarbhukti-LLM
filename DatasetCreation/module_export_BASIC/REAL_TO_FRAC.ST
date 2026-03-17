(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.1	06. apr. 2011
programmer 	alexander
tested by	hugo

this function calculates the closest fraction for a real number

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REAL_TO_FRAC

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	N :	INT;
END_VAR


VAR_OUTPUT
	REAL_TO_FRAC :	oscat_FRACTION;
END_VAR


VAR
	temp :	DINT;
	sign :	BOOL;
	X_gerundet :	DINT;
	X_ohne_Nachkomma :	REAL;
	Numerator :	DINT := 1;
	Denominator :	DINT := 0;
	Numerator_old :	DINT := 0;
	Denominator_old :	DINT := 1;
END_VAR


(*@KEY@: WORKSHEET
NAME: REAL_TO_FRAC
IEC_LANGUAGE: ST
*)
IF X < 0.0 THEN
	sign := TRUE;								(* Vorzeichen merken *)
	X := ABS(X);								(* Absolutwert berechnen *)
END_IF;

REPEAT
	X_gerundet := REAL_TO_DINT(X);

	(* Zaehler berechnen *)
	temp := numerator * X_gerundet + numerator_old;		(* Zaehler um Vorkammawert erweitern *)
	numerator_old := numerator;							(* Zaehler der letzten Berechnung speichern *)
	numerator := temp;									(* Zaehler dieser Berechnung speichern *)

	(* Nenner berechnen *)
	temp := denominator * X_gerundet + denominator_old;	(* Nenner um Vorkammawert erweitern *)
	denominator_old := denominator;						(* Nenner der letzten Berechnung speichern *)
	denominator := temp;								(* Nenner dieser Berechnung speichern *)

	(* Restwert berechnen *)
	X_ohne_Nachkomma := DINT_TO_REAL(X_gerundet);
	IF X = X_ohne_Nachkomma THEN						(* Bruch geht ohne Rest auf *)
		IF ABS(denominator) <= INT_TO_DINT(N) THEN		(* kein Rundungsfehler *)
			numerator_old := numerator;					(* Numerator_old wird von Funktion zurückgegeben *)
			denominator_old := denominator;				(* Denominator_old wird von Funktion zurückgegeben *)
		END_IF;
		EXIT;											(* keine weitere Berechnung notwendig *)
	ELSE
		X := 1.0 / (X - X_ohne_Nachkomma);				(* Kehrwert vom Rest -> Neuer Bruch *)
	END_IF;

UNTIL
	( ABS(Denominator) > INT_TO_DINT(N))
END_REPEAT;

(* correct sign if X was negative *)
IF sign THEN
	REAL_TO_FRAC.NUMERATOR := -1 * ABS(DINT_TO_INT(numerator_old));
ELSE
	REAL_TO_FRAC.NUMERATOR :=  ABS(DINT_TO_INT(numerator_old));
END_IF;

REAL_TO_FRAC.DENOMINATOR := ABS(DINT_TO_INT(denominator_old));


(* revision history
hm		19. jan. 2011	rev 1.0
	original version

ad		06. apr. 2011	rev 1.1
	optimized code
*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
