(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: TIME_DATE
*)
(*@KEY@:DESCRIPTION*)
version 2.1	7. mar. 2009
programmer 	hugo
tested by		oscat

this FUNCTION block calculates the sun position for a given date and time.
the times are calculated in utc and have to be corrected for the given time zone.
B is the angle from north and HR is the highth in degrees.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SUN_POS

(*Group:Default*)


VAR_INPUT
	LATITUDE :	REAL;(*latitude of geographical position*)
	LONGITUDE :	REAL;(*longitude of geographical position*)
	UTC :	UDINT;(*world time*)
END_VAR


VAR_OUTPUT
	B :	REAL;
	HR :	REAL;
END_VAR


VAR
	g :	REAL;
	a :	REAL;
	d :	REAL;
	h :	REAL;
	t1 :	REAL;
	n :	REAL;
	e :	REAL;
	c :	REAL;
	tau :	REAL;
	sin_d :	REAL;
	rlat :	REAL;
	sin_lat :	REAL;
	cos_lat :	REAL;
	cos_tau :	REAL;
	cos_d :	REAL;
	MATH_PI :	REAL := 3.14159265358979323846264338327950288;
	MATH_PI2 :	REAL := 6.28318530717958647692528676655900576;
END_VAR


(*@KEY@: WORKSHEET
NAME: SUN_POS
IEC_LANGUAGE: ST
*)
(* EXIT the routine IF it was executed within 10 seconds which is equal to 0.04 degrees accuracy
depending on startup conditions this could lead to a lockup for 10 seconds and not delivering a usable position
tx := T_PLC_MS();
IF tx - last < 10000 THEN RETURN; END_IF;
last := tx;
*)

(* n is the julian date and the number of days since 1.1.2000-12:00 midday *)
(* be careful for step7 date startes 1.1.1990 instead of 1.1.1970 *)
(* for step7 this line must change *)
n := UDINT_TO_REAL(UTC - UDINT#946728000) * 0.000011574074074074;
g :=MODR(6.240040768 + 0.01720197 * n, MATH_PI2);
d := MODR(4.89495042 + 0.017202792 * n, MATH_PI2) + 0.033423055 * SIN(g) + 0.000349066 * SIN(2.0*g);
e := 0.409087723 - 0.000000006981317008 * n;
cos_d := COS(d);
sin_d := SIN(d);
a := ATAN(COS(e) * sin_d / cos_d);
IF cos_d < 0.0 THEN a := a + MATH_PI; END_IF;
c := ASIN(SIN(e) * sin_d);

(* also here we must be very careful utc is from 1.1.1970 for step7 the formula must change *)
tau := RAD(MODR(6.697376 + (n - 0.25) * 0.0657098245037645 + TOD_TO_REAL(DT_TO_TOD(utc)) * 0.0000002785383333, 24.0) * 15.0 + longitude) - a;
rlat := RAD(latitude);
sin_lat := SIN(rlat);
cos_lat := COS(rlat);
cos_tau := COS(tau);
t1 := cos_tau * sin_lat - TAN(c) * cos_lat;
B := ATAN(SIN(tau) / t1);
IF t1 < 0.0 THEN B := B + MATH_PI2; ELSE B := B + MATH_PI; END_IF;
B := DEG(MODR(B, MATH_PI2));
h := DEG(ASIN(COS(C) * cos_tau * cos_lat +SIN(c) * sin_lat));
IF h > 180.0 THEN h := h - 360.0; END_IF;
(* consider refraction *)
HR := h + REFRACTION(h);


(* revision history
hm	1. feb 2007	rev 1.0
	original version

hm	6. jan 2008	rev 1.1
	performance improvements

hm	18. jan 2008	rev 1.2
	further performance improvements
	only calculate once every 10 seconds

hm	16. mar. 2008	rev 1.3
	added type conversion to avoid warnings under codesys 3.0

hm	30. jun. 2008	rev 1.4
	added type conversions to avoid warnings under codesys 3.0

hm	18. oct. 2008	rev 1.5
	using math constants

hm	17. dec. 2008	rev 1.6
	angles below horizon are displayed in negative degrees

hm	27. feb. 2009	rev 2.0
	new code with better accuracy

hm	7. mar. 2009	rev 2.1
	refraction is added after angle normalization
	deleted 10 second lockout
	added output for astronomical heigth h
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
