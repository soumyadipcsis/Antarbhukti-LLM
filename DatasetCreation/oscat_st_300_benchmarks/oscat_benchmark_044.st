VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 0;
1:
    IF x AND y THEN state := 1; ELSE state := 1;
END_CASE