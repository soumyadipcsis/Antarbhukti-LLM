(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	27 dec 2007
programmer 	oscat
tested BY	oscat

LINEAR_INT calculates an output based on a linear interpolation of up to 20 coordinates given in an array
the input coordinates have to start at the lowest array position and must be sorted ba ascending X values.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK LINEAR_INT

(*Group:Default*)


VAR_INPUT
	X :	REAL;
	XY :	oscat_XY;
	PTS :	INT;
END_VAR


VAR_OUTPUT
	LINEAR_INT :	REAL;
END_VAR


VAR
	i :	INT;
	i2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: LINEAR_INT
IEC_LANGUAGE: ST
*)
(*make sure n is bound within the array size *)
pts := MIN(pts,20);

(* calculate the linear segement interpolation *)
i := 2;
(* search for segment and calculate output
	below and above the defined segments we interpolate the last segment *)
WHILE (i < pts) AND (XY[i][0] < X) DO
	i := i + 1;
END_WHILE;

(* Hilfsvariable -> Multiprog erlaubt keine Berechnung innerhalb einer [index] angabe *)
i2 := i-1;

(* calculate the output value on the corresponding segment coordinates *)

LINEAR_INT := ((XY[i][1] - XY[i2][1]) * X - XY[i][1] * XY[i2][0] + XY[i2][1] * XY[i][0]) / (XY[i][0] - XY[i2][0]);

(* revision history
hm	7. oct 2007		rev 1.0
	original version

hm	27 dec 2007		rev 1.1
	changed code for better performance
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
