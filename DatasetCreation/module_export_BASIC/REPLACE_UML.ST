(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	29. mar. 2008
programmer 		kurt
tested by		hugo

REPLACE_UML replaces all occurences of Ä,Ö,Ü and ä,ö,ü,ß with Ae, ae, Oe, oe, Ue, ue and ss.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REPLACE_UML

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	REPLACE_UML :	STRING;
END_VAR


VAR
	pos1 :	INT;
	pos2 :	INT;
	l :	INT;
	pto :	BYTE;
	temp :	STRING;
	TO_UML :	TO_UML;
END_VAR


(*@KEY@: WORKSHEET
NAME: REPLACE_UML
IEC_LANGUAGE: ST
*)
L := LEN(str);
REPLACE_UML := str;
pos1 := 1;
pos2 := 1;
WHILE pos1 <= L AND pos2 <= 80 DO
    pto := INT_TO_BYTE(GET_CHAR(str,pos1));
	IF pto > BYTE#127 THEN
        TO_UML(IN:=pto);
        IF LEN(TO_UML.TO_UML) = 2 THEN
            temp := REPLACE_UML;
            IF pos2 >= 80 THEN
			     TO_UML.TO_UML := LEFT(TO_UML.TO_UML,1);
                 REPLACE_UML:=REPLACE(temp,TO_UML.TO_UML,1,pos2);
            ELSE
                 REPLACE_UML:=REPLACE(temp,TO_UML.TO_UML,1,pos2);
                 POS2 := POS2 +1;
            END_IF;
        END_IF;
    END_IF;
    pos1 := POS1 +1;
    pos2 := POS2 +1;
END_WHILE;

(* revision history
hm	29. feb 2008	rev 1.0
	original version

hm	29. mar. 2008	rev 1.1
	changed STRING to STRING(STRING_LENGTH)
	new code to avoid pointer out of range
	use new function to_uml
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
