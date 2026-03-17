VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 3; ELSE state := 3;
1:
    state := 2;
2:
    IF y THEN state := 3; ELSE state := 0;
3:
    state := 1;
END_CASE