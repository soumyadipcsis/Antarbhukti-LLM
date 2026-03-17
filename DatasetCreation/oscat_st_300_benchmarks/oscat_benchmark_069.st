VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF y THEN state := 1; ELSE state := 2;
2:
    IF x AND y THEN state := 1; ELSE state := 1;
END_CASE