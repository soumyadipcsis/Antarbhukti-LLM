(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: INTERN
*)
(*@KEY@:DESCRIPTION*)
version 1.1	12. nov. 2009
programmer 	hugo
tested by	oscat
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BUFFER_COMP_NW

(*Group:Default*)


VAR_IN_OUT
	PT1 :	oscat_NW_BUF_LONG;
END_VAR


VAR_INPUT
	SIZE1 :	INT;
END_VAR


VAR_IN_OUT
	PT2 :	oscat_NW_BUF_LONG;
END_VAR


VAR_INPUT
	SIZE2 :	INT;
	START :	INT;
END_VAR


VAR_OUTPUT
	BUFFER_COMP :	INT;
END_VAR


VAR
	i :	INT;
	j :	INT;
	end :	INT;
	j2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: BUFFER_COMP_NW
IEC_LANGUAGE: ST
*)
(* search for first character match *)

IF SIZE2 <= SIZE1 AND SIZE1 > 0 AND SIZE2 > 0 AND START >= 0 THEN
	end := SIZE1 - SIZE2;
	FOR i := START TO end DO
		IF PT1[i] = PT2[0] THEN
			(* first character matches, now compare rest of array *)
			j := 1;
			j2 := j + i;
			WHILE j < SIZE2 DO
				IF PT2[j] <> PT1[j2] THEN EXIT; END_IF;
				j := j + 1;
				j2 := j2 + 1;
			END_WHILE;
			(* when J > size2 a match was found return the position i in buffer1 *)
			IF j = SIZE2 THEN
				BUFFER_COMP := i;
				RETURN;
			END_IF;
		END_IF;
	END_FOR;
END_IF;
BUFFER_COMP := -1;

(*
hm 14. nov. 2008	rev 1.0
	original version

hm	12. nov. 2009	rev 1.1
	performance increase

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
