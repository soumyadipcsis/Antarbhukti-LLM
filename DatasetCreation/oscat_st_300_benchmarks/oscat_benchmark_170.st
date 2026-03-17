VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    IF x AND y THEN state := 0; ELSE state := 2;
2:
    state := 2;
3:
    IF x AND y THEN state := 1;
END_CASE