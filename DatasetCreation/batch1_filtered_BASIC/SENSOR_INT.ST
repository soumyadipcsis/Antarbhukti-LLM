(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.SENSOR
*)
(*@KEY@:DESCRIPTION*)
version 1.3	11. mar. 2009
programmer 	hugo
tested by	tobias

this function calculates the real resistance of a sensor RX given a parasitic resistor in parallel to the sensor and an additional serial resistor.
for example a parasitic parallel resistor for a PT100 can be ignored but a series resistor is the cable to the sensor.
for a humidity sensor, the parallel resistor is more dramatic and needs to be considered.
the function allows to consider a parallel and serial resistor at the same time.
with this function and known parasitic serial and parallel resistors the true resistance of the sensor can be calculated.

(*@KEY@:END_DESCRIPTION*)
FUNCTION SENSOR_INT:REAL

(*Group:Default*)


VAR_INPUT
	VOLTAGE :	REAL;
	CURRENT :	REAL;
	RP :	REAL;
	RS :	REAL;
END_VAR


VAR
	RG :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SENSOR_INT
IEC_LANGUAGE: ST
*)
IF current <> 0.0 THEN
	RG := voltage / current;
	SENSOR_INT := RP * ( RG - RS) / ( RP + RS - RG);
END_IF;

(* revisaion history

hm 20.1.2007		rev 1.1
	deleted input R0 which was not needed.

hm	2. dec 2007	rev 1.2
	corrected an error in formula and improoved speed

hm	11. mar. 2009	rev 1.3
	changed real constants to use dot syntax

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION
