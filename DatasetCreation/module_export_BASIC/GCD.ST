(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.MATHE
*)
(*@KEY@:DESCRIPTION*)
version 1.0	19. jan. 2011
programmer 	hugo
tested by	tobias

this function calculates the gretaest common divisor of two numbers A and B

(*@KEY@:END_DESCRIPTION*)
FUNCTION GCD:INT

(*Group:Default*)


VAR_INPUT
	A :	DINT;
	B :	DINT;
END_VAR


VAR
	t :	DINT;
	_A :	DINT;
	_B :	DINT;
END_VAR


(*@KEY@: WORKSHEET
NAME: GCD
IEC_LANGUAGE: ST
*)
_A := A;
_B := B;

IF _A = DINT#0 THEN
	GCD := DINT_TO_INT(ABS(_B));
ELSIF _B = DINT#0 THEN
	GCD := DINT_TO_INT(ABS(_A));
ELSE
	_A := ABS(_A);
	_B := ABS(_B);
	GCD := 1;

	WHILE NOT((DINT_TO_DWORD(_A) AND DWORD#1) > DWORD#0 OR (DINT_TO_DWORD(_B) AND DWORD#1) > DWORD#0) DO
		_A := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_A),1));
		_B := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_B),1));
		GCD := DWORD_TO_INT(SHR(INT_TO_DWORD(GCD),1));
	END_WHILE;
	WHILE _A > DINT#0 DO
		IF NOT((DINT_TO_DWORD(_A) AND DWORD#1) > DWORD#0) THEN
			_A := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_A),1));
		ELSIF NOT((DINT_TO_DWORD(_B) AND DWORD#1) > DWORD#0) THEN
			_B := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_B),1));
		ELSE
			t := DWORD_TO_DINT(SHR(DINT_TO_DWORD(ABS(_A-_B)),1));
			IF _A < _B THEN
				_B := t;
			ELSE
				_A := t;
			END_IF;
		END_IF;
	END_WHILE;
	GCD := GCD * DINT_TO_INT(_B);
END_IF;

(* revision history
hm	19. jan. 2011	rev 1.0
	original version

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION
