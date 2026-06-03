(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ACTUATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.3	17. oct. 2008
programmer 	hugo
tested by	tobias

out_ud is a up/dn or Right/left locked output driver.
it can be controlled by automatic inputs UD and ON as well as manual inputs for up and dn.
a security input to shut off at any time is prvided by the off input.
two time set inputs ton and toff specify a minimum on time for outputs and a minimum off time before the next output can become active.
the module assures that only one output can be active at any time.
for higher security pls make sure you use hardware locking of the outputs to prevent from defective wiring or outputs.
further security is provided b feedback inputs Yup_in and Ydn_in which are separate inputs for the output signal, if these inputs are not available 
pls connect them directly to Yup and Ydn.
manual mode will override automatic mode by setting the manual input high.
a status output will be 0 for normal operation or 1 - 99 for error reporting and 101 - 199 for status reporting
The status output is ESR comptible.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ACTUATOR_UD

(*Group:Default*)


VAR_INPUT
	UD :	BOOL;
	ON :	BOOL;
	MANUAL :	BOOL;
	UP :	BOOL;
	DN :	BOOL;
	OFF :	BOOL;
	YUP_IN :	BOOL;
	YDN_IN :	BOOL;
	TON :	TIME;
	TOFF :	TIME;
	OUT_RETURN :	BOOL;
END_VAR


VAR_OUTPUT
	YUP :	BOOL;
	YDN :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	tx :	TIME;
	last :	TIME;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: ACTUATOR_UD
IEC_LANGUAGE: ST
*)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

IF NOT init THEN
	(* INITIALIZATION AT FIRST CALL *)
	last := tx;
	init := TRUE;
ELSIF off THEN
	(* emergency shut off detected *)
	Yup := FALSE;
	Ydn := FALSE;
	last := tx;
	status := BYTE#101;

(* WATH FOR MIN TON TIME *)
ELSIF ((Yup OR Ydn) AND tx - last < Ton) THEN RETURN;
ELSIF NOT yup AND NOT ydn AND tx - last < toff THEN	RETURN;

(* manual operation *)
ELSIF manual THEN
	status := BYTE#102;
	(* directional chage set both outs 0 first *)
	IF yup AND NOT up OR ydn AND NOT dn THEN
		ydn := FALSE;
		yup := FALSE;
		last := tx;
	(* manual up operation *)
	ELSIF UP AND NOT DN AND NOT OFF THEN
		Ydn := FALSE;
		Yup := TRUE;
		last := tx;
		status := BYTE#103;
	(* manual down operation *)
	ELSIF DN AND NOT UP AND NOT OFF THEN
		Yup := FALSE;
		Ydn := TRUE;
		last := tx;
		status := BYTE#104;
	(* maual mode but no up or down *)
	ELSE
		IF YUP OR YDN THEN LAST := tx; END_IF;
		Yup := FALSE;
		Ydn := FALSE;
	END_IF;

(* automatic operation *)
ELSE
	(* directional change set outputs low first *)
	IF yup AND NOT ud OR ydn AND UD THEN
		yup := FALSE;
		ydn := FALSE;
		last := tx;
	(* automatic up operation *)
	ELSIF Ud AND on AND NOT OFF THEN
		Ydn := FALSE;
		Yup := TRUE;
		last := tx;
		status := BYTE#111;

	(* automatic down operation *)
	ELSIF NOT UD AND on AND NOT OFF THEN
		Yup := FALSE;
		Ydn := TRUE;
		last := tx;
		status := BYTE#112;
	(* standby mode *)
	ELSE
		IF Yup OR Ydn THEN last := tx; END_IF;
		Yup := FALSE;
		Ydn := FALSE;
		status := BYTE#110;
	END_IF;
END_IF;

(* make sure Yup and Ydn are never on at the same time *)
IF Ydn AND Yup_in AND out_return THEN
	Ydn := FALSE;
	status := BYTE#1;
END_IF;
IF Yup AND Ydn_in AND out_return THEN
	Yup := FALSE;
	status := BYTE#2;
END_IF;


(* revision history
hm 22. jan 2007	rev 1.1
	added status output
	changed inputs ton, toff to config variables
	added config var out_return to enable yup_in and Ydn_in
	manual mod will override automatic mode 

hm	15.9.2007	rev 1.2
	replaced Time() with T_PLC_MS for compatibility and performance reasons

hm	17. oct. 2008	rev 1.3
	deleted unnecessary initialization with 0
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
