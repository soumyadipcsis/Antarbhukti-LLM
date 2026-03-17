VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    state := 3;
2:
    state := 3;
3:
    IF x AND y THEN state := 1; ELSE state := 0;
END_CASE