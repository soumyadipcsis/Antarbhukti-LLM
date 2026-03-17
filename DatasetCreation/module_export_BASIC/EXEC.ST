(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: STRINGS
*)
(*@KEY@:DESCRIPTION*)
version 1.4	29. mar. 2008
programmer 	hugo
tested by	tobias

exec executes a mathematical term and returns the result as a string
the term can only be a simple term without brackets and only one operator
allowed operastors are: (+, -, *, /, ^, sqrt, sin, cos, tan).
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK EXEC

(*Group:Default*)


VAR_INPUT
	STR :	STRING;
END_VAR


VAR_OUTPUT
	EXEC :	STRING;
END_VAR


VAR
	pos :	INT;
	R1 :	REAL;
	R2 :	REAL;
	operator :	STRING;
	temp :	STRING;
	uppercase :	uppercase;
	trim :	trim;
	findB_num :	findB_num;
	findB_nonum :	findB_nonum;
END_VAR


(*@KEY@: WORKSHEET
NAME: EXEC
IEC_LANGUAGE: ST
*)
(* extract both numbers and operator *)

trim(str:=str);
temp:=trim.trim;

uppercase(str:=temp);
exec:=uppercase.uppercase;

findB_nonum(str:=exec);
pos :=findB_nonum.findB_nonum;

IF pos > 1 THEN
 temp := LEFT(EXEC,pos-1);
 findB_num(str:=temp);
 IF findB_num.findB_num > 0 THEN
   R1 := STRING_TO_REAL(temp);
 END_IF;
END_IF;
temp := RIGHT(exec,LEN(exec)-pos);
R2 := STRING_TO_REAL(temp);
exec := LEFT(exec,pos);

findB_num(str:=exec);
pos :=findB_num.findB_num;
operator := RIGHT(exec,LEN(exec) - pos);
IF EQ_STRING(operator,'') AND LEN(str) = 0 THEN
	exec := '';
	RETURN;
ELSIF EQ_STRING(operator,'') THEN
	exec := str;
	RETURN;
END_IF;
IF EQ_STRING(operator,'^') THEN
	exec := REAL_TO_STRING(EXPT(R1, R2),'%f');
ELSIF EQ_STRING(operator,'SQRT') THEN
	exec := REAL_TO_STRING(SQRT(R2),'%f');
ELSIF EQ_STRING(operator,'SIN') THEN
	exec := REAL_TO_STRING(SIN(r2),'%f');
ELSIF EQ_STRING(operator,'COS') THEN
	exec := REAL_TO_STRING(COS(r2),'%f');
ELSIF EQ_STRING(operator,'TAN') THEN
	exec := REAL_TO_STRING(TAN(R2),'%f');
ELSIF EQ_STRING(operator,'*') THEN
	exec := REAL_TO_STRING(R1 * R2,'%f');
ELSIF EQ_STRING(operator,'/') THEN
	IF R2 <> 0.0 THEN exec := REAL_TO_STRING(R1 / R2,'%f'); ELSE exec := 'ERROR'; END_IF;
ELSIF EQ_STRING(operator,'+') THEN
	exec := REAL_TO_STRING(r1 + r2,'%f');
ELSIF EQ_STRING(operator,'-') THEN
	exec := REAL_TO_STRING(r1 - r2,'%f');
ELSE
	exec := 'ERROR';
END_IF;
IF EQ_STRING(EXEC,'ERROR') THEN
	RETURN;
(* some systems deliver integer instead of real *)
ELSIF FIND(EXEC,'.') = 0 THEN
	EXEC := CONCAT(EXEC, '.0');
(* some systems deliver n. instead of n.0 ! *)
ELSE
 temp := RIGHT(EXEC,1);
 IF EQ_STRING(temp,'.') THEN
    EXEC := CONCAT(EXEC,'0');
  END_IF;
END_IF;

(* revision history

hm 	6.feb 2007		rev 1.1
	cos has to be written in uppercase
	divide by 0 will return an error

hm	5. mar. 2008	rev 1.2
	add a 0 to the string if a '.' is at the end of the string

hm	20. mar. 2008	rev 1.3
	make sure the function always returns a real value in the form of x.y

hm	29. mar. 2008	rev 1.4
	changed STRING to STRING(STRING_LENGTH)
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
