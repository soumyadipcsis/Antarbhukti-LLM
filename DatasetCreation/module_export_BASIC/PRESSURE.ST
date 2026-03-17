(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.CONVERSION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	11. mar. 2009
programmer 	hugo
tested by	oscat

this function converts different pressure units
any unused input can simply be left open.
different inputs connected at the same time will be added up.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PRESSURE

(*Group:Default*)


VAR_INPUT
	MWS :	REAL;
	TORR :	REAL;
	ATT :	REAL;
	ATM :	REAL;
	PA :	REAL;
	BAR :	REAL;
END_VAR


VAR_OUTPUT
	YMWS :	REAL;
	YTORR :	REAL;
	YATT :	REAL;
	YATM :	REAL;
	YPA :	REAL;
	YBAR :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: PRESSURE
IEC_LANGUAGE: ST
*)
Ybar := bar +
		pa * 1.0E-5 +
		0.980665 * att +
		1.01325 * atm +
		0.001333224 * torr +
		0.0980665 * mws;
Ymws := ybar * 10.1971621297793;
Ytorr := ybar * 750.0615050434140;
Yatt := ybar * 1.0197162129779;
yatm := ybar * 0.9869232667160;
Ypa := ybar * 100000.0;


(*
Druck, Pascal Pa 1 Pa = 1 N/m2 = 1 kg/(s2 ÅE m) . 0,75 ÅE 10.2 mmHg
mechanische 1 MPa = 1 N/mm2 . fur Festigkeitsangaben
Spannung Bar bar 1 bar = 105 Pa = 103 mbar = 105 kg/(s2 ÅE m)
Millimeter- mmHg 1 mmHg = 133,322 Pa = 1,333 22 mbar
Quecksilbersaule . nur in Heilkunde zulassig
physik. Atmosphare atm 1 atm = 1,013 25 bar
techn. Atmosphare at 1 at = 1 kp/cm2 = 0,980665 bar
Torr Torr 1 Torr = (101325/760) Pa = 1,333224 mbar
Meter-Wassersaule mWS 1 mWS = 9806,65 Pa = 98,0665 mbar
psi lbf/in2 1 lbf/in2 = 68,947 57 mbar = 6894,757 Pa

*)

(* revision history

hm	27. mar. 2007	rev 1.0
	original version

hm	11. mar. 2009	rev 1.1
	improved code

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
