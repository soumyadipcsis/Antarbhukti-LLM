(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ENGINEERING.AUTOMATION
*)
(*@KEY@:DESCRIPTION*)
version 1.1	14. mar. 2009
programmer 	hugo
tested by	oscat

INTERLOCK_4 detects one of 4 switches and delivers the number of the switch pressed on the output out
a output tp is true for one cycle if the output has changed.
a setup variable MODE selects between 3 different modes:
MODE = 0, any input active will disable all other inputs
MODE = 1, the input with the highest number will be acepted
mode = 2, the input last pressed will disable all others 

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK INTERLOCK_4

(*Group:Default*)


VAR_INPUT
	I0 :	BOOL;
	I1 :	BOOL;
	I2 :	BOOL;
	I3 :	BOOL;
	E :	BOOL;
	MODE :	INT;
END_VAR


VAR_OUTPUT
	OUT :	BYTE;
	TP :	BOOL;
END_VAR


VAR
	in :	BYTE;
	last :	BYTE;
	old :	BYTE;
	lmode :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: INTERLOCK_4
IEC_LANGUAGE: ST
*)
(* check if enable is active *)
IF E THEN
(* reset all vars when there is a mode change on thy fly *)
	IF mode <> lmode THEN
		out := BYTE#0;
		last := BYTE#0;
		old := BYTE#0;
		lmode := mode;
	END_IF;
	(* load inputs into in *)
	in:=BIT_LOAD_B(in,I0,0); (* in.0 *)
	in:=BIT_LOAD_B(in,I1,1); (* in.1 *)
	in:=BIT_LOAD_B(in,I2,2); (* in.2 *)
	in:=BIT_LOAD_B(in,I3,3); (* in.3 *)
	(* only execute when there is any change *)
	IF in <> last THEN
		(* only execute when inputs have chages state *)
		CASE mode OF
			0:	(* output directly display inputs as bits in byte out *)
				out := in;

			1:	(* the input with the highest number will be acepted *)
				IF    (in AND BYTE#2#00001000) > BYTE#0 (* in.3 *) THEN out := BYTE#8;
				ELSIF (in AND BYTE#2#00000100) > BYTE#0 (* in.2 *) THEN out := BYTE#4;
				ELSIF (in AND BYTE#2#00000010) > BYTE#0 (* in.1 *) THEN out := BYTE#2;
				ELSE out := in;
				END_IF;

			2:	(* input last pressed will be displayed only *)
				last := ((in XOR last) AND in);
				IF    (last AND BYTE#2#00001000) > BYTE#0 (* last.3 *) THEN out := BYTE#8;
				ELSIF (last AND BYTE#2#00000100) > BYTE#0 (* last.2 *) THEN out := BYTE#4;
				ELSIF (last AND BYTE#2#00000010) > BYTE#0 (* last.1 *) THEN out := BYTE#2;
				ELSE out := last;
				END_IF;

			3:	(* any input active will disable all other inputs *)
				IF (out AND in) = BYTE#0 THEN
					IF    (in AND BYTE#2#00001000) > BYTE#0 (* in.3 *) THEN out := BYTE#8;
					ELSIF (in AND BYTE#2#00000100) > BYTE#0 (* in.2 *) THEN out := BYTE#4;
					ELSIF (in AND BYTE#2#00000010) > BYTE#0 (* in.1 *) THEN out := BYTE#2;
					ELSE out := in;
					END_IF;
				END_IF;

		END_CASE;
		last := in;
	END_IF;
	tp := out <> old;
	old := out;
ELSE
	out := BYTE#0;
	last := BYTE#0;
	old := BYTE#0;
	lmode := 0;
	tp := FALSE;
END_IF;


(* revision history
hm	24. oct 2008	rev 1.0
	original version

hm	14. mar. 2009	rev 1.1
	replaced double assignments

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
