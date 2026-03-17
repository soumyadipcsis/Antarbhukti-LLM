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


this function block controls a hot water boiler. The Boiler can be equipped with two temperature sensors on top and bottom of the tank, T_LOWER_ENABLE must be set to True in this case.
alternatively can BOILER be configured for one (TOP) temperature sensor only (T_LOWER_ENABLE set to False).
A Pressure sensor is used to detect fresh water pressure and disable all heating if there is no water pressure. This input is dset to True by default, so if it is not used it can simply be left open.
A enable input enables the hot water heating while it is set to True. alternatively can a Ture on Req_1 or Req_2 start the heating to predefined temperatures during setup.
A low to high edge on the boost input will start heating imediately until T_upper_max is reached, it can be used to generate extra hot water when needed.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BOILER

(*Group:Default*)


VAR_INPUT
	T_UPPER :	REAL;
	T_LOWER :	REAL;
	PRESSURE :	BOOL := TRUE;
	ENABLE :	BOOL := TRUE;
	REQ_1 :	BOOL;
	REQ_2 :	BOOL;
	BOOST :	BOOL;
	T_UPPER_MIN :	REAL := REAL#50.0;
	T_UPPER_MAX :	REAL := REAL#60.0;
	T_LOWER_ENABLE :	BOOL;
	T_LOWER_MAX :	REAL := REAL#60.0;
	T_REQUEST_1 :	REAL := REAL#70.0;
	T_REQUEST_2 :	REAL := REAL#50.0;
	T_REQUEST_HYS :	REAL := REAL#5.0;
	T_PROTECT_HIGH :	REAL := REAL#80.0;
	T_PROTECT_LOW :	REAL := REAL#10.0;
END_VAR


VAR_OUTPUT
	HEAT :	BOOL;
	ERROR :	BOOL;
	STATUS :	BYTE;
END_VAR


VAR
	edge :	BOOL;
	boost_mode :	BOOL;
	flag_0 :	BOOL;
	flag_1 :	BOOL;
	flag_2 :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: BOILER
IEC_LANGUAGE: ST
*)
(* read sensors and check for valid data *)
IF t_upper > t_protect_high THEN
	status := BYTE#1;
	heat := FALSE;
	error := TRUE;
ELSIF t_upper < t_protect_low THEN
	status := BYTE#2;
	heat := TRUE;
	error := TRUE;
ELSIF t_lower > T_protect_high AND t_lower_enable THEN
	status := BYTE#3;
	heat := FALSE;
	error := TRUE;
ELSIF t_lower < t_protect_low AND t_lower_enable THEN
	status := BYTE#4;
	heat := TRUE;
	error := TRUE;
ELSIF NOT pressure THEN
	status := BYTE#5;
	heat := FALSE;
	error := TRUE;
ELSIF req_1 OR req_2 OR enable OR boost THEN
	error := FALSE;

	(* determine if heat needs to be turned on *)
	IF boost AND NOT edge AND t_upper < t_upper_max THEN
		status := BYTE#101;
		heat := TRUE;
		boost_mode := TRUE;
	ELSIF enable AND t_upper < T_upper_min THEN
		status := BYTE#102;
		heat := TRUE;
	ELSIF req_1 AND t_upper < T_request_1 THEN
		status := BYTE#103;
		heat := TRUE;
	ELSIF req_2 AND t_upper < t_request_2 THEN
		status := BYTE#104;
		heat := TRUE;
	END_IF;

	(* determine the shut off temperature *)
	IF heat THEN
		IF (enable OR boost_mode) THEN
			flag_0 := TRUE;
			IF T_lower_enable AND T_lower > T_lower_max THEN
				flag_0 := FALSE;
				boost_mode := FALSE;
			ELSIF NOT T_lower_enable AND T_upper > T_upper_max THEN
				flag_0 := FALSE;
				boost_mode := FALSE;
			END_IF;
		ELSE
			flag_0 := FALSE;
		END_IF;
		flag_1 := (req_1 AND T_upper > T_request_1 + T_request_hys) AND req_1;
		flag_2 := (req_2 AND T_upper > T_request_2 + T_request_hys) AND req_2;

		(* shut off heat if no longer needed *)
		heat := flag_0 OR flag_1 OR flag_2;
		IF heat = FALSE THEN status := BYTE#100; END_IF;
	END_IF;
ELSE
	status := BYTE#100;
	heat := FALSE;
	error := FALSE;
END_IF;
edge := boost;


(* revision history
hm	27. feb. 2007	rev 1.0
	original version

hm	16. oct. 2008	rev 1.1
	improved performance

hm	13. mar. 2009	rev 1.2
	real constants updated to new systax using dot

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
