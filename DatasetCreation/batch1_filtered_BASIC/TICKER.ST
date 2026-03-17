(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.2	29. mar. 2008
programmer 	hugo
tested by	tobias

Ticker sends a substring of text with length N every TD Milliseconds to generate a ticker.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK TICKER

(*Group:Default*)


VAR_INPUT
	N :	INT;
	PT :	TIME;
	TEXT :	STRING;
END_VAR


VAR_OUTPUT
	DISPLAY :	STRING;
END_VAR


VAR
	delay :	TP;
	rollout :	STRING;
	text_len :	INT;
	rollout_step :	INT;
	step :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: TICKER
IEC_LANGUAGE: ST
*)
(* generate next ticker when delay is low *)
text_len := LEN(text);

IF N < text_len THEN
	IF NOT delay.Q THEN

		IF step > text_len THEN
            rollout_step := 0;
            rollout := '';
            step := 0;
        END_IF;

        IF step + N > text_len THEN
		    (* increase step for next tick *)
		    step := step + 1;
            rollout_step := rollout_step +1;
		    (* extract dispay from text *)
		    display := MID(text, N - rollout_step, step);
            rollout := CONCAT(rollout,'#'); 
            display := CONCAT(display,rollout);
        ELSE
		    (* increase step for next tick *)
		    step := step + 1;
		    (* extract dispay from text *)
		    display := MID(text, N, step);
        END_IF;

		(* set delay timer for next tick *)
		delay(in := TRUE, PT := PT);
	ELSE;
		(* execute delay timer *)
		delay(in := FALSE);
	END_IF;
ELSE
	display := text;
END_IF;

(* revision history
hm	4. dec. 2007	rev 1.0
	original version

hm	15. dec. 2007	rev 1.1
	step now starts at 1 instaed of 0

hm	29. mar. 2008	rev 1.2
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
