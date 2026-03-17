(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	10. mar. 2009
programmer 	oscat
tested BY	oscat

POLYNOM_INT calculates an output based on a Polynom interpolation of up to 5 coordinates given in an array
the indut coordinates have to start at the lowest array position and must be sorted ba ascending X values.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK POLYNOM_INT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	XY :	oscat_Polynom_XY;
END_VAR


VAR
	XY2 :	oscat_Polynom_XY;
END_VAR


VAR_INPUT
	PTS :	INT;
END_VAR


VAR_OUTPUT
	POLYNOM_INT :	REAL;
END_VAR


VAR
	I :	INT;
	J :	INT;
	J_1 :	INT;
	J_I :	INT;
	INIT :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: POLYNOM_INT
IEC_LANGUAGE: ST
*)
(*make sure n is bound within the array size *)
pts := MIN_INT(pts, 5);

(* this part is only to calculate the polynom parameters, which are then stores in the Y array
	the array values, it is not needed during runtime, unless the parameters will change during runtime
	the remaining code without this setup code can be used within a function to calculate specific functions
	the content of the arrays is then used as constant values within the function *)

IF (init = FALSE) THEN
	init := TRUE;

    (* Daten kopieren *)
	FOR i := 1 TO pts DO
       	FOR j := 0 TO 1 DO
           		XY2[i][j] := XY[i][j];
		END_FOR;
	END_FOR;

	FOR i := 1 TO pts DO
        J := pts;
		WHILE (J >= i+1) DO
          j_i := j-i;
		  j_1 := J-1;
          XY2[j][1] := (XY2[j][1] - XY2[j_1][1]) / (XY2[j][0] - XY2[j_i][0]);
          j := j - 1;
		END_WHILE;
	END_FOR;
END_IF;

(* this part is the actual calculation *)
i := pts;
POLYNOM_INT := 0.0;

WHILE (i >= 1) DO
  POLYNOM_INT := POLYNOM_INT * (X - XY2[i][0]) + XY2[i][1];
  i := i - 1;
END_WHILE;

(* revision history
hm	8. okt 2007	rev 1.0
	original version

hm	17. dec 2007	rev 1.1
	init makes no sense for a function

hm	22. feb 2008	rev 1.2
	improved performance

hm	10. mar. 2009	rev 1.3
	changed syntax of real constants to 0.0

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
