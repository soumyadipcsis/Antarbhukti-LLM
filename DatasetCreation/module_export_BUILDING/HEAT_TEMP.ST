(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: HLK
*)
(*@KEY@:DESCRIPTION*)
version 1.2	13. mar. 2009
programmer 	hugo
tested by	oscat

Heat_Temp calculates a heat characteristic based on the formula: tv=ti+(tvmax-ti)*((ti-tau)/(ti-taumin))^(1/n)
while
tv necessary heating temperature.
ti internal room temperature (20∞C)
tau current external temperature
taumin external temperature to determine characteristics
C exponent for heating system (normally 1,33 or 1,1 for floor heating)

The two additional inputs TY_min and TY_max set limits for the output TY, while an offset inputs allows to rise or lower the room temperature.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK HEAT_TEMP

(*Group:Default*)


VAR_INPUT
	T_EXT :	REAL;
	T_INT :	REAL;
	OFFSET :	REAL;
	T_REQ :	REAL;
	TY_MAX :	REAL := REAL#70.0;
	TY_MIN :	REAL := REAL#25.0;
	TY_CONFIG :	REAL := REAL#70.0;
	T_INT_CONFIG :	REAL := REAL#20.0;
	T_EXT_CONFIG :	REAL := REAL#-15.0;
	T_DIFF :	REAL := REAL#10.0;
	C :	REAL := REAL#1.33;
	H :	REAL := REAL#3.0;
END_VAR


VAR_OUTPUT
	TY :	REAL;
	HEAT :	BOOL;
END_VAR


VAR
	tr :	REAL;
	tx :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: HEAT_TEMP
IEC_LANGUAGE: ST
*)
tr := T_INT + OFFSET;
tx := (tr - T_EXT) / (T_INT_CONFIG - T_EXT_CONFIG);

IF T_EXT + H > tr THEN
	TY := 0.0;
ELSE
	TY := LIMIT(TY_MIN, tr + T_DIFF * 0.5 * tx + (TY_CONFIG - T_DIFF * 0.5 - tr) * EXPT(tx, 1.0 / C), TY_MAX);
END_IF;

TY := MAX(TY, T_REQ);
HEAT := TY > 0.0;


(*

tv=ti+(tvmax-ti)*((ti-tau)/(ti-taumin))^(1/n)

tv aktuelle Vorlauftemp.
ti Raumtemperatur innen (20∞C)
tau aktuelle Auﬂentemperatur
taumin minimale Auﬂentemperatur -12∞C oder -15∞C
n Heizkˆrperexponent (meistens 1,33)
Fuﬂbodenheizung = 1,1
Wandheizung 1,3

Normen z. B. DIN 4703, DIN 4725 oder die Literatur, z. B Recknagel Abschnitt 1.3.5.

*)


(* revision history
hm	27. jan. 2008	rev 1.0
	original version

hm	26. sep. 2008	rev 1.1
	moved T_INT from config to Input
	added config variable H
	corrected error in formula

hm	13. mar. 2009	rev 1.2
	improved code

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
